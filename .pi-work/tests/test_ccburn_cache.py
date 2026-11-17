import importlib.util
import json
import multiprocessing
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

HELPER = Path.home() / ".claude/hooks/ccburn-cache.py"
spec = importlib.util.spec_from_file_location("ccburn_cache", HELPER)
cache = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cache)


def success(command, **kwargs):
    return subprocess.CompletedProcess(command, 0, stdout="Session: 2% · Weekly: 97%\n")


def concurrent_refresh(directory, barrier, calls):
    barrier.wait(timeout=10)

    def run(command, **kwargs):
        with calls.get_lock():
            calls.value += 1
        return success(command, **kwargs)

    cache.refresh(Path(directory), now=lambda: 1000, runner=run)


class CacheTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name) / "profile"

    def test_fresh_cache_is_reused_and_refreshes_after_a_minute(self):
        calls = []

        def run(command, **kwargs):
            calls.append(command)
            return success(command, **kwargs)

        first = cache.refresh(self.directory, now=lambda: 1000, runner=run)
        second = cache.refresh(self.directory, now=lambda: 1059, runner=run)
        self.assertEqual(first, second)
        self.assertEqual(len(calls), 1)
        cache.refresh(self.directory, now=lambda: 1060, runner=run)
        self.assertEqual(len(calls), 2)

    def test_eight_processes_launch_ccburn_only_once(self):
        ctx = multiprocessing.get_context("fork")
        barrier = ctx.Barrier(8)
        calls = ctx.Value("i", 0)
        workers = [ctx.Process(target=concurrent_refresh, args=(str(self.directory), barrier, calls)) for _ in range(8)]
        try:
            for worker in workers:
                worker.start()
            for worker in workers:
                worker.join(timeout=15)
                self.assertEqual(worker.exitcode, 0)
            self.assertEqual(calls.value, 1)
        finally:
            for worker in workers:
                if worker.is_alive():
                    worker.terminate()
                    worker.join()

    def test_failure_retains_old_value_and_backs_off_five_minutes(self):
        cache.refresh(self.directory, now=lambda: 1000, runner=success)
        failures = []

        def fail(command, **kwargs):
            failures.append(command)
            raise subprocess.CalledProcessError(1, command)

        state = cache.refresh(self.directory, now=lambda: 1060, runner=fail)
        self.assertEqual(state["next_attempt"], 1360)
        self.assertIn("Session: 2%", state["text"])
        self.assertTrue(cache.render(state, now=lambda: 1060).endswith(" (stale)"))
        cache.refresh(self.directory, now=lambda: 1359, runner=fail)
        self.assertEqual(len(failures), 1)
        state = cache.refresh(self.directory, now=lambda: 1360, runner=success)
        self.assertFalse(state["error"])

    def test_interrupted_attempt_still_throttles_the_next_caller(self):
        self.directory.mkdir()
        cache.write_state(self.directory, {"last_attempt": 1000, "next_attempt": 1060})
        calls = []
        cache.refresh(self.directory, now=lambda: 1001, runner=lambda *a, **k: calls.append(a))
        self.assertEqual(calls, [])

    def test_native_limits_are_collected_before_rendering_without_saving_input(self):
        calls = []
        payload = json.dumps({"rate_limits": {"five_hour": {"used_percentage": 2}}, "other": "not-persisted"})

        def run(command, **kwargs):
            calls.append((command, kwargs))
            return success(command, **kwargs)

        cache.refresh(self.directory, payload, now=lambda: 1000, runner=run)
        self.assertEqual([call[0] for call in calls], [["ccburn", "collect"], ["ccburn", "--compact", "--once"]])
        self.assertEqual(calls[0][1]["input"], payload)
        self.assertNotIn("not-persisted", (self.directory / "state.json").read_text())

    def test_profile_caches_are_separate_and_paths_are_normalized(self):
        with patch.dict(os.environ, {"XDG_CACHE_HOME": self.temporary.name, "CLAUDE_CONFIG_DIR": "/tmp/claude-a"}):
            first = cache.cache_dir()
            with patch.dict(os.environ, {"CLAUDE_CONFIG_DIR": "/tmp/claude-a/../claude-a"}):
                self.assertEqual(first, cache.cache_dir())
            with patch.dict(os.environ, {"CLAUDE_CONFIG_DIR": "/tmp/claude-b"}):
                self.assertNotEqual(first, cache.cache_dir())

    def test_missing_and_malformed_cache_and_old_values_are_explicit(self):
        self.assertEqual(cache.read_state(self.directory), {})
        self.directory.mkdir()
        (self.directory / "state.json").write_text("invalid json")
        self.assertEqual(cache.read_state(self.directory), {})
        self.assertEqual(cache.render({"error": True}), "usage unavailable")
        self.assertEqual(cache.render({"text": "old", "updated": 1000}, now=lambda: 1121), "old (stale)")

    def test_cached_cli_never_creates_state_or_launches_a_refresh(self):
        env = {**os.environ, "XDG_CACHE_HOME": self.temporary.name, "CLAUDE_CONFIG_DIR": "/tmp/test-read-only-profile"}
        result = subprocess.run([sys.executable, str(HELPER), "--cached"], env=env, capture_output=True, text=True, check=True)
        self.assertEqual(result.stdout.strip(), "usage loading…")
        self.assertFalse(list(Path(self.temporary.name).rglob("state.json")))


if __name__ == "__main__":
    unittest.main()
