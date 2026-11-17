import { homedir } from "node:os";
import { join } from "node:path";
import { stripVTControlCharacters } from "node:util";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const STATUS_KEY = "ccburn";
const REFRESH_MS = 60_000;

type UsageResult = { code: number; stdout: string; killed?: boolean; truncated?: boolean };

export function formatUsage(result: UsageResult): string {
  const usage = stripVTControlCharacters(result.stdout).replace(/\s+/g, " ").trim();
  return result.code === 0 && !result.killed && !result.truncated && usage
    ? `Claude ${usage}`
    : "Claude usage unavailable";
}

export default function ccburnFooter(pi: ExtensionAPI): void {
  let context: ExtensionContext | undefined;
  let timer: ReturnType<typeof setInterval> | undefined;
  let request: AbortController | undefined;

  const stop = () => {
    const previous = context;
    context = undefined;
    if (timer) clearInterval(timer);
    timer = undefined;
    request?.abort();
    request = undefined;
    previous?.ui.setStatus(STATUS_KEY, undefined);
  };

  const refresh = async () => {
    if (!context || request) return;
    const current = context;
    const controller = new AbortController();
    request = controller;
    try {
      // Match the Claude provider's profile without reading or copying its credentials.
      const profile = process.env.PI_CLAUDE_CODE_CONFIG_DIR;
      const helper = join(homedir(), ".claude", "hooks", "ccburn-cache.py");
      const command = profile ? "env" : "python3";
      const args = profile
        ? [`CLAUDE_CONFIG_DIR=${profile}`, "python3", helper, "--refresh"]
        : [helper, "--refresh"];
      const result = await pi.exec(command, args, {
        signal: controller.signal,
        timeout: 55_000,
        maxBuffer: 16_384,
      });
      if (!controller.signal.aborted && context === current) {
        const text = formatUsage(result);
        current.ui.setStatus(STATUS_KEY, text);
        pi.events.emit("local:claude-usage", text);
      }
    } catch {
      if (!controller.signal.aborted && context === current) {
        current.ui.setStatus(STATUS_KEY, "Claude usage unavailable");
        pi.events.emit("local:claude-usage", "Claude usage unavailable");
      }
    } finally {
      if (request === controller) request = undefined;
    }
  };

  pi.on("session_start", (_event, ctx) => {
    stop();
    if (!ctx.hasUI || process.env.PI_SUBAGENT_ID) return;
    context = ctx;
    ctx.ui.setStatus(STATUS_KEY, "Claude usage loading…");
    void refresh();
    timer = setInterval(() => void refresh(), REFRESH_MS);
    timer.unref();
  });

  pi.on("session_shutdown", stop);
}
