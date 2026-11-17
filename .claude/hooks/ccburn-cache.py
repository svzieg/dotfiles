#!/usr/bin/env python3
"""Shared Claude/Pi usage cache. No credentials or status-line input are persisted."""

import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import time

REFRESH_SECONDS = 60
FAILURE_BACKOFF_SECONDS = 300


def cache_dir():
    profile = Path(os.environ.get("CLAUDE_CONFIG_DIR", "~/.claude")).expanduser().resolve()
    key = hashlib.sha256(str(profile).encode()).hexdigest()[:16]
    root = Path(os.environ.get("XDG_CACHE_HOME", "~/.cache")).expanduser()
    return root / "ccburn" / "statusline" / key


def read_state(directory):
    try:
        state = json.loads((directory / "state.json").read_text())
        return state if isinstance(state, dict) else {}
    except (OSError, ValueError):
        return {}


def write_state(directory, state):
    with tempfile.NamedTemporaryFile("w", dir=directory, delete=False) as output:
        temporary = Path(output.name)
        json.dump(state, output)
    try:
        temporary.replace(directory / "state.json")
    finally:
        temporary.unlink(missing_ok=True)


def refresh(directory, payload="", *, now=time.time, runner=subprocess.run):
    directory.mkdir(mode=0o700, parents=True, exist_ok=True)
    with (directory / "refresh.lock").open("a") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return read_state(directory)
        state = read_state(directory)
        attempted = now()
        # Recheck inside the cross-process lock; record attempts before spawning ccburn.
        if attempted < state.get("next_attempt", 0):
            return state
        state.update(last_attempt=attempted, next_attempt=attempted + REFRESH_SECONDS)
        write_state(directory, state)
        try:
            try:
                data = json.loads(payload) if payload else {}
            except ValueError:
                data = {}
            if isinstance(data, dict) and data.get("rate_limits"):
                runner(
                    ["ccburn", "collect"], input=payload, text=True,
                    capture_output=True, timeout=15, check=True,
                )
            result = runner(
                ["ccburn", "--compact", "--once"], text=True,
                capture_output=True, timeout=30, check=True,
            )
            text = result.stdout.strip()
            if not text:
                raise ValueError("Empty ccburn output")
            state.update(text=text, updated=now(), error=False)
        except (OSError, ValueError, subprocess.SubprocessError):
            state.update(error=True, next_attempt=now() + FAILURE_BACKOFF_SECONDS)
        write_state(directory, state)
        return state


def render(state, *, now=time.time):
    text = state.get("text")
    if not text:
        return "usage unavailable" if state.get("error") else "usage loading…"
    stale = state.get("error") or now() - state.get("updated", 0) > 2 * REFRESH_SECONDS
    return text + (" (stale)" if stale else "")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cached", action="store_true", help="Read only; never launch ccburn")
    parser.add_argument("--refresh", action="store_true", help="Refresh if due (the default)")
    args = parser.parse_args()
    directory = cache_dir()
    if args.cached:
        state = read_state(directory)
    else:
        payload = "" if sys.stdin.isatty() else sys.stdin.read()
        state = refresh(directory, payload)
    print(render(state))


if __name__ == "__main__":
    main()
