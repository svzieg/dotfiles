/**
 * pi-idle-trim — trim a session's context mechanically (no model call) once its prompt cache is gone.
 *
 * Why: after a break longer than the provider's prompt-cache lifetime, the next request re-bills the
 * whole conversation at cache-write prices ($2.5–4/M). A compaction at that moment pays the same
 * re-write, so it saves nothing. This extension trims *before* that request is sent, with no provider
 * call at all, so the request only has to write what is left.
 *
 * What it does, exactly:
 *  - Never runs on a timer, never sends a request, never touches a live cache.
 *  - On the first message you send after the cache deadline, it performs Pi's own compaction flow with
 *    a deterministic digest instead of an LLM summary (`usage` omitted, so no tokens are spent).
 *  - The digest keeps what humans wrote (your messages), the previous summary, commands run, files
 *    touched and tool errors. The dropped part stays in the session tree (`/tree`) — nothing is lost
 *    from disk, only from the context that gets re-sent.
 *
 * Configuration: environment variables (see README). Commands: /idle-trim [status|preview|now].
 */
import type { ExtensionAPI, ExtensionContext, SessionEntry } from "@earendil-works/pi-coding-agent";

/** Marker we pass through `ctx.compact({ customInstructions })` to recognise our own compaction. */
const TRIM = "idle-trim";
const PREVIEW = "idle-trim-preview";
/** Pi's own errors we treat as "nothing to do" instead of a warning (agent-session). */
const BENIGN = new Set(["Nothing to compact (session too small)", "Already compacted", "Compaction cancelled"]);

// ─── configuration ───────────────────────────────────────────────────────────

function envInt(name: string, fallback: number): number {
	const raw = process.env[name];
	if (raw === undefined || raw.trim() === "") return fallback;
	const value = Number(raw);
	return Number.isFinite(value) && value >= 0 ? Math.floor(value) : fallback;
}

function envOn(name: string, fallback: boolean): boolean {
	const raw = process.env[name]?.trim().toLowerCase();
	if (!raw) return fallback;
	return raw === "1" || raw === "true" || raw === "yes" || raw === "on";
}

function config() {
	const retention = (process.env.PI_IDLE_TRIM_RETENTION ?? "").trim().toLowerCase();
	return {
		off: envOn("PI_IDLE_TRIM_OFF", false),
		/** Do not bother below this measured context size; small re-writes are cheap. */
		minTokens: envInt("PI_IDLE_TRIM_MIN_TOKENS", 100_000),
		/** Budget for the digest, in tokens (approximated at 4 characters per token). */
		digestTokens: envInt("PI_IDLE_TRIM_DIGEST_TOKENS", 6_000),
		/** Characters kept per user message in the digest. */
		userChars: envInt("PI_IDLE_TRIM_USER_CHARS", 600),
		/** Only trim at `session_shutdown` (best effort); off by default — see README. */
		trimOnQuit: envOn("PI_IDLE_TRIM_QUIT", false),
		/** "short" | "long" | "" (infer from the last request's cache write). */
		retention: retention === "short" || retention === "long" ? retention : "",
		/** Extra time added to the cache lifetime before a trim is allowed. */
		graceMs: envInt("PI_IDLE_TRIM_GRACE_MS", 0),
	};
}

// ─── prompt-cache deadline ───────────────────────────────────────────────────

function promptCacheSeconds(model: any, tier: "short" | "long"): number | undefined {
	const value = model?.promptCache?.[tier];
	return typeof value === "number" && value > 0 ? value : undefined;
}

type Activity = { at?: number; tokens?: number; wrote1h?: boolean; wroteShort?: boolean };

/** Last moment the cache was used or refreshed, plus the size and lifetime tier of that request. */
function lastActivity(branch: SessionEntry[]): Activity {
	const activity: Activity = {};
	for (const entry of branch as any[]) {
		if (entry?.type === "message" && entry.message?.role === "assistant") {
			const at = typeof entry.message.timestamp === "number" ? entry.message.timestamp : undefined;
			if (at !== undefined) {
				activity.at = at;
				const usage = entry.message.usage;
				if (usage) {
					activity.tokens = (usage.input ?? 0) + (usage.cacheRead ?? 0) + (usage.cacheWrite ?? 0);
					if ((usage.cacheWrite1h ?? 0) > 0) activity.wrote1h = true;
					else if ((usage.cacheWrite ?? 0) > 0) activity.wroteShort = true;
				}
			}
		} else if (entry?.type === "usage" && entry.kind === "cache_warm") {
			const at = Date.parse(entry.timestamp);
			if (Number.isFinite(at)) activity.at = at;
		}
	}
	return activity;
}

type Deadline = { at: number; seconds: number; tier: "short" | "long"; tokens: number; expired: boolean };

function cacheDeadline(ctx: ExtensionContext): Deadline | undefined {
	const cfg = config();
	const branch = ctx.sessionManager.getBranch();
	const activity = lastActivity(branch);
	if (activity.at === undefined) return undefined;

	// Prefer an explicit choice, then what the last request actually did (1 h writes mean the long tier).
	let tier: "short" | "long" = activity.wrote1h ? "long" : "short";
	if (cfg.retention) tier = cfg.retention;
	let seconds = promptCacheSeconds(ctx.model, tier);
	if (seconds === undefined && tier === "long") {
		tier = "short";
		seconds = promptCacheSeconds(ctx.model, "short");
	}
	if (seconds === undefined) return undefined; // provider publishes no lifetime: leave the session alone

	const at = activity.at + seconds * 1000;
	return { at, seconds, tier, tokens: activity.tokens ?? 0, expired: Date.now() >= at + cfg.graceMs };
}

// ─── digest ──────────────────────────────────────────────────────────────────

const truncate = (value: string, max: number): string =>
	value.length <= max ? value : `${value.slice(0, Math.max(0, max - 1)).trimEnd()}…`;

const collapse = (value: string): string => value.replace(/\s+/gu, " ").trim();

/** Flatten a message's content (string or content blocks) to plain text. */
function textOf(content: any): string {
	if (typeof content === "string") return content;
	if (!Array.isArray(content)) return "";
	const parts: string[] = [];
	for (const block of content) {
		if (typeof block === "string") parts.push(block);
		else if (block?.type === "text" && typeof block.text === "string") parts.push(block.text);
		else if (block?.type === "image") parts.push("[image]");
	}
	return parts.join("\n");
}

function toolCallLines(message: any): { calls: string[]; files: string[]; errors: string[] } {
	const calls: string[] = [];
	const files: string[] = [];
	const errors: string[] = [];
	for (const block of Array.isArray(message?.content) ? message.content : []) {
		if (block?.type !== "toolCall" && block?.type !== "tool_use") continue;
		const name = String(block.name ?? "tool");
		const args = block.arguments ?? {};
		const path = args.path ?? args.file_path ?? args.filePath ?? args.file;
		if (typeof path === "string" && path) files.push(`${name} ${path}`);
		const detail =
			typeof args.command === "string"
				? collapse(args.command)
				: typeof args.pattern === "string"
					? collapse(args.pattern)
					: typeof path === "string"
						? path
						: "";
		calls.push(`${name}${detail ? `: ${truncate(detail, 120)}` : ""}`);
	}
	if (message?.role === "toolResult") {
		if (message.isError) errors.push(`${message.toolName ?? "tool"}: ${truncate(collapse(textOf(message.content)), 240)}`);
		const name = String(message.toolName ?? "tool");
		const args = message.arguments ?? {};
		const path = args.path ?? args.file_path;
		if (typeof path === "string" && path) files.push(`${name} ${path}`);
	}
	return { calls, files, errors };
}

/**
 * Deterministic replacement for Pi's LLM summary. Priority order, bounded by the token budget:
 * previous summary → your own messages → commands → files → errors → assistant notes.
 */
function buildDigest(preparation: any, cfg: ReturnType<typeof config>): string {
	const budget = Math.max(1_000, cfg.digestTokens) * 4; // chars
	const messages: any[] = [...(preparation?.messagesToSummarize ?? []), ...(preparation?.turnPrefixMessages ?? [])];

	const userLines: string[] = [];
	const notes: string[] = [];
	const seenCalls = new Set<string>();
	const calls: string[] = [];
	const seenFiles = new Set<string>();
	const files: string[] = [];
	const errors: string[] = [];

	for (const message of messages) {
		if (message?.role === "user") {
			const text = collapse(textOf(message.content));
			if (text) userLines.push(truncate(text, cfg.userChars));
		} else if (message?.role === "assistant") {
			const text = collapse(textOf(message.content));
			if (text) notes.push(truncate(text, 200));
			const extracted = toolCallLines(message);
			for (const call of extracted.calls) if (!seenCalls.has(call)) (seenCalls.add(call), calls.push(call));
			for (const file of extracted.files) if (!seenFiles.has(file)) (seenFiles.add(file), files.push(file));
			for (const error of extracted.errors) errors.push(error);
		} else {
			const extracted = toolCallLines(message);
			for (const call of extracted.calls) if (!seenCalls.has(call)) (seenCalls.add(call), calls.push(call));
			for (const file of extracted.files) if (!seenFiles.has(file)) (seenFiles.add(file), files.push(file));
			for (const error of extracted.errors) errors.push(error);
		}
	}

	const out: string[] = [];
	let used = 0;
	const push = (text: string) => {
		if (!text) return;
		if (used + text.length > budget) return;
		out.push(text);
		used += text.length + 1;
	};

	push(
		`# Context trimmed mechanically (no model call) at ${new Date().toISOString()}\n\n` +
			`${messages.length} earlier message(s) before this point were removed from the context. ` +
			`Nothing was deleted: the full transcript is still in the session tree (\`/tree\`).`,
	);
	if (preparation?.previousSummary) {
		push(`\n## Earlier summary (verbatim)\n\n${truncate(preparation.previousSummary, Math.floor(budget * 0.4))}`);
	}
	if (userLines.length > 0) {
		const capped: string[] = [];
		for (let index = userLines.length - 1; index >= 0; index--) {
			const line = userLines[index];
			if (used + line.length > budget * 0.75 && capped.length > 0) break;
			capped.unshift(`- ${line}`);
		}
		push(`\n## Your requests (oldest first)\n\n${capped.join("\n")}`);
	}
	if (calls.length > 0) {
		push(`\n## Commands and tool calls\n\n${calls.slice(0, 60).map((line) => `- ${line}`).join("\n")}`);
	}
	if (files.length > 0) {
		push(`\n## Files touched\n\n${files.slice(0, 80).map((line) => `- ${line}`).join("\n")}`);
	}
	if (errors.length > 0) {
		push(`\n## Tool errors\n\n${errors.slice(0, 20).map((line) => `- ${line}`).join("\n")}`);
	}
	if (notes.length > 0) {
		push(`\n## Assistant notes\n\n${notes.slice(-15).map((line) => `- ${line}`).join("\n")}`);
	}
	return out.join("\n");
}

// ─── extension ───────────────────────────────────────────────────────────────

export default function piIdleTrim(pi: ExtensionAPI): void {
	let lastTrim: { tokensBefore: number; digestChars: number } | undefined;
	let previewPath: string | undefined;

	const notify = (ctx: ExtensionContext, message: string, kind: "info" | "warning" | "error" = "info") => {
		if (ctx.hasUI) ctx.ui.notify(message, kind);
		else console.error(`[idle-trim] ${message}`);
	};

	const canCompact = (ctx: ExtensionContext): boolean => typeof (ctx as any)?.compact === "function";

	const describe = (ctx: ExtensionContext): string => {
		const deadline = cacheDeadline(ctx);
		if (!deadline) return "idle-trim: this model publishes no prompt-cache lifetime — never trims.";
		const minutes = Math.round(Math.abs(deadline.at - Date.now()) / 60_000);
		return (
			`idle-trim: ${deadline.tier} cache (${Math.round(deadline.seconds / 60)} min), ` +
			`${deadline.expired ? `expired ${minutes} min ago` : `alive for ${minutes} min`}, ` +
			`context ${Math.round(deadline.tokens / 1000)}k, trims at ${Math.round(config().minTokens / 1000)}k`
		);
	};

	// Our own compaction flow: subclass in Pi's compaction event, no provider call.
	pi.on("session_before_compact", async (event: any) => {
		const marker = event?.customInstructions;
		if (marker !== TRIM && marker !== PREVIEW) return undefined;
		const preparation = event?.preparation;
		if (!preparation) return undefined;

		const digest = buildDigest(preparation, config());
		if (marker === PREVIEW) {
			const fs = await import("node:fs/promises");
			const os = await import("node:os");
			const path = await import("node:path");
			previewPath = path.join(os.tmpdir(), `pi-idle-trim-digest-${Date.now()}.md`);
			await fs.writeFile(previewPath, digest, "utf8");
			return { cancel: true };
		}
		lastTrim = { tokensBefore: preparation.tokensBefore ?? 0, digestChars: digest.length };
		return {
			compaction: {
				summary: digest,
				firstKeptEntryId: preparation.firstKeptEntryId,
				tokensBefore: preparation.tokensBefore,
			},
		};
	});

	/**
	 * The one automatic path: the first message sent after the cache deadline. Ahead of it, Pi is asked
	 * to compact; our hook above answers with the digest, so no request is made and no tokens are spent.
	 */
	pi.on("input", async (event: any, ctx: ExtensionContext) => {
		const cfg = config();
		if (cfg.off || event?.source === "extension" || !canCompact(ctx)) return { action: "continue" as const };
		if (typeof (ctx as any).isIdle === "function" && !(ctx as any).isIdle()) return { action: "continue" as const };

		const deadline = cacheDeadline(ctx);
		if (!deadline || !deadline.expired) return { action: "continue" as const };
		if (deadline.tokens < cfg.minTokens) return { action: "continue" as const };

		const error = await new Promise<Error | undefined>((resolve) => {
			ctx.compact({
				customInstructions: TRIM,
				onComplete: () => resolve(undefined),
				onError: (reason: Error) => resolve(reason),
			});
		});

		if (error && !BENIGN.has(error.message)) {
			notify(ctx, `idle-trim: trim failed, sending as-is (${error.message})`, "warning");
		} else if (!error && lastTrim) {
			const after = Math.max(1, Math.round(lastTrim.digestChars / 4));
			notify(
				ctx,
				`idle-trim: trimmed ${Math.round(lastTrim.tokensBefore / 1000)}k → ~${Math.round(after / 1000)}k + tail ` +
					`(no model call, $0). Full transcript in /tree.`,
			);
		}
		return { action: "continue" as const };
	});

	// Best effort only, and off by default: see README ("Why not trim on quit").
	pi.on("session_shutdown", (event: any, ctx: ExtensionContext) => {
		if (!config().trimOnQuit || event?.reason !== "quit") return;
		try {
			const deadline = cacheDeadline(ctx);
			if (!deadline || deadline.tokens < config().minTokens) return;
			ctx.compact({ customInstructions: TRIM, onError: () => {} });
		} catch {
			// Shutting down; never fail the exit for this.
		}
	});

	pi.registerCommand("idle-trim", {
		description: "Trim context mechanically (no model call) once the prompt cache is gone: status | preview | now",
		handler: async (args: string, ctx: ExtensionContext) => {
			const action = (args ?? "").trim().toLowerCase();
			if ((action === "now" || action === "trim" || action === "preview") && !canCompact(ctx)) {
				notify(ctx, "idle-trim: compaction is unavailable in this mode.", "warning");
				return;
			}

			if (action === "now" || action === "trim") {
				const error = await new Promise<Error | undefined>((resolve) => {
					ctx.compact({
						customInstructions: TRIM,
						onComplete: () => resolve(undefined),
						onError: (reason: Error) => resolve(reason),
					});
				});
				if (error) {
					notify(ctx, BENIGN.has(error.message) ? "idle-trim: nothing to trim." : `idle-trim: ${error.message}`, "warning");
					return;
				}
				notify(
					ctx,
					lastTrim
						? `idle-trim: trimmed ${Math.round(lastTrim.tokensBefore / 1000)}k context, no model call.`
						: "idle-trim: done.",
				);
				return;
			}

			if (action === "preview") {
				previewPath = undefined;
				const error = await new Promise<Error | undefined>((resolve) => {
					ctx.compact({
						customInstructions: PREVIEW,
						onComplete: () => resolve(undefined),
						onError: (reason: Error) => resolve(reason),
					});
				});
				if (error && !BENIGN.has(error.message)) notify(ctx, `idle-trim: ${error.message}`, "warning");
				else if (previewPath) notify(ctx, `idle-trim: preview of the digest written to ${previewPath} (session unchanged).`);
				else notify(ctx, "idle-trim: nothing to preview.");
				return;
			}

			notify(ctx, describe(ctx));
		},
	});
}
