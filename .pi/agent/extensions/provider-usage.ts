import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const REFRESH_MS = 60_000;
const CODEX_ORIGIN = "https://chatgpt.com";

/** Compact time-until-reset, e.g. 78 → "1h 18m", 549703 → "6d 8h", 1209600 → "14d". */
export function formatDuration(seconds: number): string {
  if (!Number.isFinite(seconds) || seconds <= 0) return "";
  const minutes = Math.floor(seconds / 60);
  if (minutes < 1) return "<1m";
  if (minutes < 60) return `${minutes}m`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return minutes % 60 ? `${hours}h ${minutes % 60}m` : `${hours}h`;
  const days = Math.floor(hours / 24);
  return hours % 24 ? `${days}d ${hours % 24}h` : `${days}d`;
}

const suffix = (seconds: number) => {
  const text = formatDuration(seconds);
  return text ? ` (${text})` : "";
};

export function formatCodexWeekly(payload: any): string {
  const windows = [payload?.rate_limit?.primary_window, payload?.rate_limit?.secondary_window];
  const weekly = windows.find((window) => window?.limit_window_seconds === 604_800);
  const used = weekly?.used_percent;
  if (!(typeof used === "number" && Number.isFinite(used) && used >= 0 && used <= 100)) {
    return "Codex weekly unavailable";
  }
  const left = typeof weekly?.reset_after_seconds === "number"
    ? weekly.reset_after_seconds
    : typeof weekly?.reset_at === "number" ? weekly.reset_at - Date.now() / 1000 : NaN;
  return `Codex Weekly: ${Math.round(used)}% used${suffix(left)}`;
}

export function formatNeuralwatt(payload: any): string {
  const quotas = payload?.quotas;
  const num = (v: unknown): v is number => typeof v === "number" && Number.isFinite(v);
  const parts: string[] = [];
  const remaining = quotas?.subscription?.kwh_remaining;
  if (num(remaining)) {
    const ends = Date.parse(quotas?.subscription?.current_period_end);
    parts.push(`${remaining.toFixed(2)} kWh left (month)${suffix((ends - Date.now()) / 1000)}`);
  }
  const free = quotas?.daily_free_energy?.kwh_remaining;
  if (num(free)) {
    const reset = Date.parse(quotas?.daily_free_energy?.reset_at);
    parts.push(`${free.toFixed(2)} kWh free (day)${suffix((reset - Date.now()) / 1000)}`);
  }
  if (parts.length) return `Neuralwatt: ${parts.join(" · ")}`;
  const credits = quotas?.balance?.credits_remaining_usd;
  return num(credits) ? `Neuralwatt: $${credits.toFixed(2)} left` : "Neuralwatt usage unavailable";
}

export async function fetchCodexWeekly(ctx: ExtensionContext, signal: AbortSignal): Promise<string> {
  const registry = ctx.modelRegistry;
  const provider = registry.getProvider("openai-codex");
  const auth = await registry.getProviderAuth("openai-codex");
  signal.throwIfAborted();
  // Never send a proxy credential or an API key to the consumer subscription endpoint.
  if (auth?.source !== "OAuth" || !auth.auth.apiKey) throw new Error("Codex OAuth unavailable");
  for (const url of [provider?.baseUrl, auth.auth.baseUrl]) {
    if (url && new URL(url).origin !== CODEX_ORIGIN) throw new Error("Custom Codex origin");
  }
  const token = auth.auth.apiKey;
  const claims = JSON.parse(Buffer.from(token.split(".")[1], "base64url").toString("utf8"));
  const account = claims?.["https://api.openai.com/auth"]?.chatgpt_account_id;
  if (typeof account !== "string" || !account) throw new Error("Codex account unavailable");
  const response = await fetch(`${CODEX_ORIGIN}/backend-api/wham/usage`, {
    headers: { Authorization: `Bearer ${token}`, "chatgpt-account-id": account },
    signal,
    redirect: "error",
  });
  if (!response.ok) throw new Error("Codex usage unavailable");
  return formatCodexWeekly(await response.json());
}

export function compactUsage(claude: string | undefined, codex: string, neuralwatt: string): string[] {
  const meters: string[] = [];
  // A meter the account cannot provide is noise, not information: omit it instead of
  // printing "n/a" for providers this machine has no credentials or tooling for (no
  // ccburn, no Codex OAuth, no Neuralwatt key). Loading states still show "…" so a slow
  // fetch is not mistaken for "no provider".
  const fetched = (value: string | undefined): boolean => !!value && !/unavailable/i.test(value);
  if (fetched(claude)) {
    // ccburn --compact prints "Session: 🔥 66% (1h 41m) · Weekly: 🧊 11% · Monthly: 🧊 $1.46".
    // ccburn only prints the reset countdown for the 5h session window.
    const value = (label: string): string | undefined => {
      const match = claude!.match(new RegExp(`${label}:\\s*[^\\dA-Za-z%]*(\\d+(?:\\.\\d+)?)%\\s*(?:\\(([^)]+)\\))?`, "i"));
      const number = match ? Number(match[1]) : NaN;
      if (!Number.isFinite(number) || number < 0 || number > 100) return undefined;
      // The trailing "(stale)" marker from the cache helper is not a reset countdown.
      const extra = match?.[2] && !/^stale$/i.test(match[2]) ? match[2] : "";
      return `${number}%${extra ? ` (${extra})` : ""}`;
    };
    const fiveHour = value("Session");
    const weekly = value("Weekly");
    if (fiveHour || weekly || claude!.includes("loading")) {
      meters.push(`Claude 5h ${fiveHour ?? "…"} wk ${weekly ?? "…"}${claude!.includes("(stale)") ? " (stale)" : ""}`);
    }
  }
  if (fetched(codex)) {
    meters.push(codex.replace("Codex Weekly: ", "Codex wk ").replace(" used", "")
      .replace("Codex weekly loading…", "Codex wk …"));
  }
  if (fetched(neuralwatt)) {
    meters.push(neuralwatt.replace("Neuralwatt: ", "NW ").replace(" kWh left (month)", "kWh left").replace(" kWh free (day)", "kWh free")
      .replace("Neuralwatt usage loading…", "NW …"));
  }
  return meters;
}

export function wrapUsage(meters: string[], width: number): string[] {
  const available = Math.max(1, width - 2);
  const lines: string[] = [];
  let line = "";
  for (let meter of meters) {
    if (line && line.length + 3 + meter.length > available) {
      lines.push(` ${line}`);
      line = "";
    }
    while (meter.length > available) {
      lines.push(` ${meter.slice(0, available)}`);
      meter = meter.slice(available);
    }
    line = line ? `${line} │ ${meter}` : meter;
  }
  if (line) lines.push(` ${line}`);
  return lines;
}

export default function providerUsage(pi: ExtensionAPI): void {
  let context: ExtensionContext | undefined;
  let timer: ReturnType<typeof setInterval> | undefined;
  let request: AbortController | undefined;
  let unsubscribe: (() => void)[] = [];
  let lastNeuralwattUpdate = 0;
  let claude: string | undefined;
  let codex = "Codex weekly loading…";
  let neuralwatt = "Neuralwatt usage loading…";

  const draw = () => {
    if (!context) return;
    const meters = compactUsage(claude, codex, neuralwatt);
    context.ui.setWidget("provider-usage", (_tui, theme) => ({
      render: (width: number) => wrapUsage(meters, width).map((line) => theme.fg("muted", line)),
      invalidate() {},
    }), { placement: "belowEditor" });
  };
  const publish = (key: string, text: string) => {
    if (key === "codex-weekly") codex = text;
    else neuralwatt = text;
    context?.ui.setStatus(key, text);
    draw();
  };

  const stop = () => {
    if (timer) clearInterval(timer);
    timer = undefined;
    request?.abort();
    request = undefined;
    for (const off of unsubscribe) off();
    unsubscribe = [];
    context?.ui.setStatus("neuralwatt-usage", undefined);
    context?.ui.setStatus("codex-weekly", undefined);
    context?.ui.setWidget("provider-usage", undefined);
    context = undefined;
  };

  const refresh = async () => {
    if (!context) return;
    const current = context;
    if (Date.now() - lastNeuralwattUpdate > 2 * REFRESH_MS) {
      publish("neuralwatt-usage", "Neuralwatt usage unavailable");
    }
    // Reuse the provider's authenticated quota API and its live response/SSE updates.
    pi.events.emit("neuralwatt:quotas:request", undefined);
    if (request) return;
    const controller = new AbortController();
    request = controller;
    const timeout = setTimeout(() => controller.abort(), 15_000);
    try {
      const text = await fetchCodexWeekly(current, controller.signal);
      if (context === current && request === controller && !controller.signal.aborted) {
        publish("codex-weekly", text);
      }
    } catch {
      if (context === current && request === controller) {
        publish("codex-weekly", "Codex weekly unavailable");
      }
    } finally {
      clearTimeout(timeout);
      if (request === controller) request = undefined;
    }
  };

  pi.on("session_start", (_event, ctx) => {
    stop();
    if (!ctx.hasUI || process.env.PI_SUBAGENT_ID) return;
    context = ctx;
    lastNeuralwattUpdate = Date.now();
    claude = undefined;
    publish("codex-weekly", "Codex weekly loading…");
    publish("neuralwatt-usage", "Neuralwatt usage loading…");
    unsubscribe.push(pi.events.on("neuralwatt:quotas:updated", (data: unknown) => {
      lastNeuralwattUpdate = Date.now();
      publish("neuralwatt-usage", formatNeuralwatt(data));
    }));
    unsubscribe.push(pi.events.on("local:claude-usage", (data: unknown) => {
      if (typeof data !== "string") return;
      claude = data;
      draw();
    }));
    // Package providers load before local extensions; defer work until our hook returns.
    queueMicrotask(() => { if (context === ctx) void refresh(); });
    timer = setInterval(() => void refresh(), REFRESH_MS);
    timer.unref();
  });
  pi.on("session_shutdown", stop);
}
