# pi-idle-trim

Trim a Pi session's context **mechanically — no model call, no tokens spent** — at the moment its
prompt cache is gone, i.e. right before the first request that would otherwise re-bill the whole
conversation at cache-write prices.

Measured on this machine before writing it: 29 of 41 notice-worthy cache misses in `piw` came from
idle gaps longer than the 1 h cache lifetime, $18.65 of cache-write cost on those turns alone
(1–2 h worktree hops: $7.96, overnight: $7.61, lunch/meetings: $2.67).

## Why not just compact?

A compaction at that moment asks the provider to summarise the whole branch — it pays the same
re-write, plus summary output. Compacting *while warm* costs a full-history re-write of the new
prefix for a cheap benefit. This extension takes the third option: replace the AI summary with a
deterministic digest, so the compaction itself is free and Pi only has to write the trimmed context.

## Install

One package directory, installed into both profiles (Pi records a local package by its resolved path,
so there is no second copy):

```bash
pi  install /home/u500132/coding/pi-extensions/pi-idle-trim
piw install /home/u500132/coding/pi-extensions/pi-idle-trim
```

Then `/reload` in a running session, or restart.

## What happens when you resume after a break

It is a **pre-input hook gated on the cache deadline**, not a timer and not a post-TTL job:

1. You type a message.
2. Before it is sent, the extension reads the last request in the branch, checks the model's
   `promptCache` lifetime (5 min, or 1 h — inferred from the last request's `cacheWrite1h`, overridable),
   and compares it with the clock.
3. If the deadline has passed **and** the context is above `PI_IDLE_TRIM_MIN_TOKENS`, it runs Pi's own
   compaction flow with a deterministic digest. No request, `usage` omitted → $0.
4. Your message is then sent against the trimmed context: reads `~30 k` instead of writing `300–500 k`.

No timers exist, so nothing happens while you are away, and a session you only open to read is never
touched.

## Commands

| Command | Effect |
|---|---|
| `/idle-trim` | status: tier, deadline, context size, threshold |
| `/idle-trim preview` | writes the digest it *would* use to `$TMPDIR/pi-idle-trim-digest-*.md`, session unchanged |
| `/idle-trim now` | trim now (use before you leave: free, and the resume is fast) |

## Configuration (environment)

| Variable | Default | Meaning |
|---|---|---|
| `PI_IDLE_TRIM_MIN_TOKENS` | `100000` | Do not trim below this measured context size |
| `PI_IDLE_TRIM_DIGEST_TOKENS` | `6000` | Digest budget (≈ 4 chars/token) |
| `PI_IDLE_TRIM_USER_CHARS` | `600` | Characters kept per user message |
| `PI_IDLE_TRIM_OFF` | `0` | `1` disables the input hook entirely |
| `PI_IDLE_TRIM_RETENTION` | *inferred* | `short` or `long`, if you want to force the tier |
| `PI_IDLE_TRIM_GRACE_MS` | `0` | Extra wait before a trim is allowed |
| `PI_IDLE_TRIM_QUIT` | `0` | Trim at `session_shutdown` (best effort) |

Put them in the `piw` wrapper or your shell alias.

## What the digest keeps / drops

Kept, in this priority order until the budget is used: the previous summary verbatim, **every user
message** (truncated to `PI_IDLE_TRIM_USER_CHARS`), tool calls and commands, files touched, tool
errors, assistant notes (last 15, 200 chars each).

Dropped: reasoning blocks, tool result bodies, and message bodies beyond the caps.

Nothing is deleted from disk. Pi saves a normal compaction entry, so the removed messages stay in the
session tree — `/tree` still reaches them, and `/idle-trim preview` lets you read the digest before
trusting it on a session that matters.

## Why trimming on quit is off by default

At `session_shutdown` the cache is still warm (you just used it). Trimming then turns a cheap resume —
cache read at $0.10/M, e.g. $0.05 for 500 k — into a write at $2.5–4/M, i.e. ~$1.20 for the same
session. The lazy path above is strictly better: $0 while warm, only the small write when cold. Enable
`PI_IDLE_TRIM_QUIT=1` only if you always resume cold.

## Limits

- Models without a `promptCache` lifetime in `models.json` / `models-store.json` (for example
  `openai-codex/*`) never trim — no published lifetime, no guess.
- Cache lifetimes are best-effort. A provider may keep a cache longer than its stated tier; if that
  happens the trim costs one write you did not have to make.
- The digest is deterministic, not clever. If a dropped region needs judgement, use `/compact` (Pi's
  AI compaction) instead, or `pi-precompact` to make that summary latency-free.

## Uninstall

```bash
pi  remove /home/u500132/coding/pi-extensions/pi-idle-trim
piw remove /home/u500132/coding/pi-extensions/pi-idle-trim
```
