import assert from "node:assert/strict";
import test from "node:test";
import providerUsage, { fetchCodexWeekly, formatCodexWeekly, formatDuration, formatNeuralwatt, compactUsage, wrapUsage } from "../../.pi/agent/extensions/provider-usage.ts";
import workProviderUsage from "../agent/extensions/provider-usage.ts";

const weekly = { rate_limit: { primary_window: { limit_window_seconds: 18_000, used_percent: 3 }, secondary_window: { limit_window_seconds: 604_800, used_percent: 42.4 } } };
const quota = { quotas: { subscription: { kwh_remaining: 12.345 } } };
const token = `header.${Buffer.from(JSON.stringify({ "https://api.openai.com/auth": { chatgpt_account_id: "test-account" } })).toString("base64url")}.signature`;
function registry() {
  return {
    getProvider: () => ({ baseUrl: "https://chatgpt.com/backend-api" }),
    getProviderAuth: async () => ({ source: "OAuth", auth: { apiKey: token } }),
  };
}
function fixture(factory = providerUsage, hasUI = true) {
  const hooks = new Map();
  const listeners = new Map();
  const statuses = new Map();
  const widgets = new Map();
  const emitted = [];
  const ctx = { hasUI, modelRegistry: registry(), ui: {
    setStatus: (key, value) => statuses.set(key, value),
    setWidget: (key, value, options) => widgets.set(key, { value, options }),
  } }; 
  factory({
    on: (name, handler) => hooks.set(name, handler),
    events: {
      on: (name, handler) => { listeners.set(name, handler); return () => listeners.delete(name); },
      emit: (name, data) => { emitted.push(name); listeners.get(name)?.(data); },
    },
  });
  return { hooks, listeners, statuses, widgets, emitted, ctx };
}
const flush = () => new Promise((resolve) => setImmediate(resolve));

test("formats the weekly Codex window by duration, never mistakes 5h for weekly", () => {
  assert.equal(formatCodexWeekly(weekly), "Codex Weekly: 42% used");
  assert.equal(formatCodexWeekly({ rate_limit: { primary_window: weekly.rate_limit.secondary_window } }), "Codex Weekly: 42% used");
  for (const value of [undefined, {}, { rate_limit: { secondary_window: { limit_window_seconds: 604_800, used_percent: NaN } } }]) {
    assert.equal(formatCodexWeekly(value), "Codex weekly unavailable");
  }
});

test("duration picks the largest readable unit", () => {
  assert.equal(formatDuration(78), "1m");
  assert.equal(formatDuration(4_680), "1h 18m");
  assert.equal(formatDuration(3_600), "1h");
  assert.equal(formatDuration(549_703), "6d 8h");
  assert.equal(formatDuration(1_209_600), "14d");
  for (const value of [NaN, Infinity, 0, -5]) assert.equal(formatDuration(value), "");
});

test("codex and neuralwatt show time until reset when the payload has it", () => {
  const window = (extra) => ({ limit_window_seconds: 604_800, used_percent: 32, ...extra });
  assert.equal(formatCodexWeekly({ rate_limit: { primary_window: window({ reset_after_seconds: 549_703 }) } }), "Codex Weekly: 32% used (6d 8h)");
  assert.equal(formatCodexWeekly({ rate_limit: { secondary_window: window({ reset_at: Date.now() / 1000 + 3_600 }) } }), "Codex Weekly: 32% used (1h)");
  const end = new Date(Date.now() + 14 * 86_400_000).toISOString();
  assert.equal(formatNeuralwatt({ quotas: { subscription: { kwh_remaining: 12.345, current_period_end: end } } }), "Neuralwatt: 12.35 kWh left (month) (14d)");
});

test("Neuralwatt shows monthly energy, falls back to credits, rejects malformed data", () => {
  assert.equal(formatNeuralwatt(quota), "Neuralwatt: 12.35 kWh left (month)");
  assert.equal(formatNeuralwatt({ quotas: { subscription: { kwh_remaining: 0 } } }), "Neuralwatt: 0.00 kWh left (month)");
  assert.equal(formatNeuralwatt({ quotas: { balance: { credits_remaining_usd: 9 } } }), "Neuralwatt: $9.00 left");
  for (const value of [null, {}, { quotas: { subscription: { kwh_remaining: Infinity } } }]) {
    assert.equal(formatNeuralwatt(value), "Neuralwatt usage unavailable");
  }
});

test("compact row keeps 5h, weekly and monthly remaining units explicit", () => {
  assert.deepEqual(compactUsage("Claude Session: 2% · Weekly: 97% (stale)", "Codex Weekly: 42% used", "Neuralwatt: 12.35 kWh left (month)"),
    ["Claude 5h 2% wk 97% (stale)", "Codex wk 42%", "NW 12.35kWh left"]);
  assert.deepEqual(compactUsage(undefined, "Codex weekly unavailable", "Neuralwatt usage loading…"), ["Codex wk n/a", "NW …"]);
  assert.equal(compactUsage("Claude Weekly: 999%", "Codex weekly loading…", "Neuralwatt usage unavailable")[0], "Claude 5h n/a wk n/a");
  assert.equal(compactUsage("Claude Session: 🚨 41% (3h 54m) · Weekly: 🧊 7% · Monthly: 🧊 $1.46", "Codex weekly loading…", "Neuralwatt usage unavailable")[0], "Claude 5h 41% (3h 54m) wk 7%");
  assert.equal(compactUsage("Claude Weekly: unavailable · Monthly: 42%", "Codex weekly loading…", "Neuralwatt usage unavailable")[0], "Claude 5h n/a wk n/a");
  assert.deepEqual(compactUsage("Claude Session: 🔥 67% (1h 18m) · Weekly: 🧊 11%", "Codex Weekly: 32% used (6d 8h)", "Neuralwatt: 12.35 kWh left (month) (14d)"),
    ["Claude 5h 67% (1h 18m) wk 11%", "Codex wk 32% (6d 8h)", "NW 12.35kWh left (14d)"]);
});

test("usage wraps at meter boundaries and never exceeds even a very narrow terminal", () => {
  const meters = ["Claude 5h 2% wk 97%", "Codex wk 42%", "NW 12.35kWh left"];
  assert.deepEqual(wrapUsage(meters, 80), [" Claude 5h 2% wk 97% │ Codex wk 42% │ NW 12.35kWh left"]);
  assert.deepEqual(wrapUsage(meters, 40), [" Claude 5h 2% wk 97% │ Codex wk 42%", " NW 12.35kWh left"]);
  for (const width of [3, 10, 20, 40, 80]) {
    const lines = wrapUsage(meters, width);
    assert.ok(lines.every((line) => line.length <= width));
    assert.equal(lines.join("").replaceAll(" │ ", "").replaceAll(" ", ""), meters.join("").replaceAll(" ", ""));
  }
});

test("Codex uses profile runtime OAuth and account header, rejects redirects, proxies and API keys", async () => {
  const originalFetch = globalThis.fetch;
  let calls = 0;
  globalThis.fetch = async (url, options) => {
    calls++;
    assert.equal(url, "https://chatgpt.com/backend-api/wham/usage");
    assert.equal(options.headers.Authorization, `Bearer ${token}`);
    assert.equal(options.headers["chatgpt-account-id"], "test-account");
    assert.equal(options.redirect, "error");
    return { ok: true, json: async () => weekly };
  };
  try {
    const ctx = { modelRegistry: registry() };
    assert.equal(await fetchCodexWeekly(ctx, new AbortController().signal), "Codex Weekly: 42% used");
    for (const auth of [
      { source: "API key", auth: { apiKey: token } },
      { source: "OAuth", auth: { apiKey: token, baseUrl: "https://proxy.example" } },
      { source: "OAuth", auth: { apiKey: "not-a-jwt" } },
    ]) {
      ctx.modelRegistry.getProviderAuth = async () => auth;
      await assert.rejects(fetchCodexWeekly(ctx, new AbortController().signal));
    }
    ctx.modelRegistry = registry();
    ctx.modelRegistry.getProvider = () => ({ baseUrl: "https://proxy.example" });
    await assert.rejects(fetchCodexWeekly(ctx, new AbortController().signal));
    assert.equal(calls, 1, "rejected credentials never leave the process");
  } finally { globalThis.fetch = originalFetch; }
});

test("both profiles display a muted dedicated row; Claude updates join it; shutdown clears the row", async () => {
  const originalFetch = globalThis.fetch;
  globalThis.fetch = async () => ({ ok: true, json: async () => weekly });
  try {
    for (const factory of [providerUsage, workProviderUsage]) {
      const f = fixture(factory);
      f.hooks.get("session_start")({}, f.ctx);
      await flush();
      assert.ok(f.emitted.includes("neuralwatt:quotas:request"));
      f.listeners.get("neuralwatt:quotas:updated")(quota);
      assert.equal(f.statuses.get("neuralwatt-usage"), "Neuralwatt: 12.35 kWh left (month)");
      assert.equal(f.statuses.get("codex-weekly"), "Codex Weekly: 42% used");
      f.listeners.get("local:claude-usage")("Claude Session: 2% · Weekly: 97%");
      const widget = f.widgets.get("provider-usage");
      assert.equal(widget.options.placement, "belowEditor");
      const component = widget.value({}, { fg: (color, text) => { assert.equal(color, "muted"); return text; } });
      assert.deepEqual(component.render(80), [" Claude 5h 2% wk 97% │ Codex wk 42% │ NW 12.35kWh left"]);
      f.hooks.get("session_shutdown")();
      assert.equal(f.widgets.get("provider-usage").value, undefined);
      assert.equal(f.listeners.size, 0);
      assert.equal(f.statuses.get("neuralwatt-usage"), undefined);
      assert.equal(f.statuses.get("codex-weekly"), undefined);
    }
  } finally { globalThis.fetch = originalFetch; }
});

test("headless sessions and subagents do not poll", async () => {
  const previous = process.env.PI_SUBAGENT_ID;
  try {
    for (const hasUI of [false, true]) {
      if (hasUI) process.env.PI_SUBAGENT_ID = "test";
      const f = fixture(workProviderUsage, hasUI);
      f.hooks.get("session_start")({}, f.ctx);
      await flush();
      assert.equal(f.emitted.length, 0);
      assert.equal(f.statuses.size, 0);
    }
  } finally {
    if (previous === undefined) delete process.env.PI_SUBAGENT_ID;
    else process.env.PI_SUBAGENT_ID = previous;
  }
});

test("refreshes once a minute without overlapping requests and reports provider errors safely", async () => {
  const originalFetch = globalThis.fetch;
  const originalSet = globalThis.setInterval;
  const originalClear = globalThis.clearInterval;
  let tick;
  let cleared = false;
  let calls = 0;
  let reject;
  globalThis.setInterval = (callback, ms) => {
    assert.equal(ms, 60_000);
    tick = callback;
    return { unref() {} };
  };
  globalThis.clearInterval = () => { cleared = true; };
  globalThis.fetch = () => {
    calls++;
    return new Promise((_resolve, fail) => { reject = fail; });
  };
  const f = fixture(workProviderUsage);
  try {
    f.hooks.get("session_start")({}, f.ctx);
    await flush();
    tick();
    await flush();
    assert.equal(calls, 1);
    reject(new Error("secret provider response must not appear in footer"));
    await flush();
    assert.equal(f.statuses.get("codex-weekly"), "Codex weekly unavailable");
    tick();
    await flush();
    assert.equal(calls, 2);
    assert.equal(f.emitted.filter((name) => name === "neuralwatt:quotas:request").length, 3);
    reject(new Error("network unavailable"));
    await flush();
    f.hooks.get("session_shutdown")();
    assert.equal(cleared, true);
  } finally {
    f.hooks.get("session_shutdown")();
    globalThis.fetch = originalFetch;
    globalThis.setInterval = originalSet;
    globalThis.clearInterval = originalClear;
  }
});

test("shutdown aborts pending Codex fetches and ignores late responses", async () => {
  const originalFetch = globalThis.fetch;
  let complete;
  let signal;
  globalThis.fetch = async (_url, options) => {
    signal = options.signal;
    return new Promise((resolve) => { complete = () => resolve({ ok: true, json: async () => weekly }); });
  };
  const f = fixture(workProviderUsage);
  try {
    f.hooks.get("session_start")({}, f.ctx);
    await flush();
    f.hooks.get("session_shutdown")();
    assert.equal(signal.aborted, true);
    complete();
    await flush();
    assert.equal(f.statuses.get("codex-weekly"), undefined);
  } finally { f.hooks.get("session_shutdown")(); globalThis.fetch = originalFetch; }
});
