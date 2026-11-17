import assert from "node:assert/strict";
import { homedir } from "node:os";
import { join } from "node:path";
import test from "node:test";
import ccburnFooter, { formatUsage } from "../agent/extensions/ccburn.ts";

const usage = { code: 0, stdout: "Session: 2% · Weekly: 97%" };

function fixture(exec, hasUI = true) {
  const hooks = new Map();
  const statuses = [];
  const events = [];
  const ctx = { hasUI, ui: { setStatus: (key, value) => statuses.push([key, value]) } };
  ccburnFooter({ on: (name, handler) => hooks.set(name, handler), exec, events: { emit: (name, value) => events.push([name, value]) } });
  return { hooks, statuses, events, ctx };
}

async function withTimers(run) {
  const originalSet = globalThis.setInterval;
  const originalClear = globalThis.clearInterval;
  const timers = new Set();
  globalThis.setInterval = (callback, ms) => {
    assert.equal(ms, 60_000);
    const timer = { callback, unref() {} };
    timers.add(timer);
    return timer;
  };
  globalThis.clearInterval = (timer) => timers.delete(timer);
  try {
    await run(timers);
  } finally {
    globalThis.setInterval = originalSet;
    globalThis.clearInterval = originalClear;
  }
}

test("formats ccburn as one plain-text footer status", () => {
  assert.equal(
    formatUsage({ code: 0, stdout: "\u001b[31mSession: 2%\u001b[0m\n Weekly: 97%\t" }),
    "Claude Session: 2% Weekly: 97%",
  );
  for (const result of [
    { code: 1, stdout: "error" },
    { code: 0, stdout: " " },
    { ...usage, killed: true },
    { ...usage, truncated: true },
  ]) assert.equal(formatUsage(result), "Claude usage unavailable");
});

test("starts only with an interactive session and refreshes without overlapping", async () => {
  await withTimers(async (timers) => {
    const calls = [];
    const pending = [];
    const f = fixture((command, args, options) => {
      calls.push({ command, args, options });
      return new Promise((resolve) => pending.push(resolve));
    });
    assert.equal(calls.length, 0, "factory must not launch background work");
    f.hooks.get("session_start")({}, f.ctx);
    assert.equal(calls.length, 1);
    assert.equal(timers.size, 1);
    [...timers][0].callback();
    assert.equal(calls.length, 1, "a slow ccburn request must not overlap");
    assert.deepEqual(calls[0].args.slice(-2), [join(homedir(), ".claude", "hooks", "ccburn-cache.py"), "--refresh"]);
    assert.equal(calls[0].options.timeout, 55_000);
    pending.shift()(usage);
    await Promise.resolve();
    assert.deepEqual(f.statuses.at(-1), ["ccburn", "Claude Session: 2% · Weekly: 97%"]);
    assert.deepEqual(f.events.at(-1), ["local:claude-usage", "Claude Session: 2% · Weekly: 97%"]);
    [...timers][0].callback();
    assert.equal(calls.length, 2);
    f.hooks.get("session_shutdown")();
    assert.equal(timers.size, 0);
    assert.equal(calls[1].options.signal.aborted, true);
    pending.shift()(usage);
    await Promise.resolve();
    assert.deepEqual(f.statuses.at(-1), ["ccburn", undefined], "late results must not restore a stopped status");
  });
});

test("skips headless sessions and subagents", async () => {
  await withTimers(async (timers) => {
    let calls = 0;
    const f = fixture(async () => { calls++; return usage; }, false);
    f.hooks.get("session_start")({}, f.ctx);
    assert.equal(calls, 0);
    const previous = process.env.PI_SUBAGENT_ID;
    try {
      process.env.PI_SUBAGENT_ID = "test-child";
      const child = fixture(async () => { calls++; return usage; });
      child.hooks.get("session_start")({}, child.ctx);
      assert.equal(calls, 0);
      assert.equal(timers.size, 0);
    } finally {
      if (previous === undefined) delete process.env.PI_SUBAGENT_ID;
      else process.env.PI_SUBAGENT_ID = previous;
    }
  });
});

test("honors the provider's Claude profile and reports command failures", async () => {
  await withTimers(async () => {
    const previous = process.env.PI_CLAUDE_CODE_CONFIG_DIR;
    process.env.PI_CLAUDE_CODE_CONFIG_DIR = "/tmp/test claude profile";
    let call;
    const f = fixture(async (command, args) => {
      call = { command, args };
      throw new Error("ccburn missing or unavailable");
    });
    try {
      f.hooks.get("session_start")({}, f.ctx);
      await Promise.resolve();
      assert.deepEqual(call, {
        command: "env",
        args: ["CLAUDE_CONFIG_DIR=/tmp/test claude profile", "python3", join(homedir(), ".claude", "hooks", "ccburn-cache.py"), "--refresh"],
      });
      assert.deepEqual(f.statuses.at(-1), ["ccburn", "Claude usage unavailable"]);
    } finally {
      f.hooks.get("session_shutdown")();
      if (previous === undefined) delete process.env.PI_CLAUDE_CODE_CONFIG_DIR;
      else process.env.PI_CLAUDE_CODE_CONFIG_DIR = previous;
    }
  });
});
