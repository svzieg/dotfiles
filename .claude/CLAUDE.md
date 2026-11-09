@RTK.md

# context-mode — MANDATORY routing rules

context-mode MCP tools available. Rules protect context window from flooding. One unrouted command dumps 56 KB into context.

## Think in Code — MANDATORY

Analyze/count/filter/compare/search/parse/transform data: **write code** via `ctx_execute(language, code)`, `console.log()` only the answer. Do NOT read raw data into context. PROGRAM the analysis, not COMPUTE it. Pure JavaScript — Node.js built-ins only (`fs`, `path`, `child_process`). `try/catch`, handle `null`/`undefined`. One script replaces ten tool calls.

## BLOCKED — do NOT attempt

### curl / wget — BLOCKED

Intercepted and replaced with error. Do NOT retry.
Use: `ctx_fetch_and_index(url, source)` or `ctx_execute(language: "javascript", code: "const r = await fetch(...)")`

### Inline HTTP — BLOCKED

`fetch('http`, `requests.get(`, `requests.post(`, `http.get(`, `http.request(` — intercepted. Do NOT retry.
Use: `ctx_execute(language, code)` — only stdout enters context

### WebFetch — BLOCKED

Use: `ctx_fetch_and_index(url, source)` then `ctx_search(queries)`

## REDIRECTED — use sandbox

### Bash (>20 lines output)

Bash ONLY for: `git`, `mkdir`, `rm`, `mv`, `cd`, `ls`, `npm install`, `pip install`.
Otherwise: `ctx_batch_execute(commands, queries)` or `ctx_execute(language: "shell", code: "...")`

### Read (for analysis)

Reading to **Edit** → Read correct. Reading to **analyze/explore/summarize** → `ctx_execute_file(path, language, code)`.

### Grep — may flood context

Use `ctx_execute(language: "shell", code: "grep ...")` in sandbox.

## Tool selection

0. **MEMORY**: `ctx_search(sort: "timeline")` — after resume, check prior context before asking user.
1. **GATHER**: `ctx_batch_execute(commands, queries)` — runs all commands, auto-indexes, returns search. ONE call replaces 30+. Each command: `{label: "header", command: "..."}`.
2. **FOLLOW-UP**: `ctx_search(queries: ["q1", "q2", ...])` — all questions as array, ONE call (default relevance mode).
3. **PROCESSING**: `ctx_execute(language, code)` | `ctx_execute_file(path, language, code)` — sandbox, only stdout enters context.
4. **WEB**: `ctx_fetch_and_index(url, source)` then `ctx_search(queries)` — raw HTML never enters context.
5. **INDEX**: `ctx_index(content, source)` — store in FTS5 for later search.

## Parallel I/O batches

For multi-URL fetches or multi-API calls, **always** include `concurrency: N` (1-8):

- `ctx_batch_execute(commands: [3+ network commands], concurrency: 5)` — gh, curl, dig, docker inspect, multi-region cloud queries
- `ctx_fetch_and_index(requests: [{url, source}, ...], concurrency: 5)` — multi-URL batch fetch

**Use concurrency 4-8** for I/O-bound work (network calls, API queries). **Keep concurrency 1** for CPU-bound (npm test, build, lint) or commands sharing state (ports, lock files, same-repo writes).

GitHub API rate-limit: cap at 4 for `gh` calls.

## Subagent routing

Routing block auto-injected into subagent prompts. Bash-type subagents upgraded to general-purpose. No manual instruction needed.

## Output

Write artifacts to FILES — never inline. Return: file path + 1-line description.
Descriptive source labels for `ctx_search(source: "label")`.

## Session Continuity

Skills, roles, and decisions persist for the entire session. Do not abandon them as the conversation grows.

## Memory

Session history is persistent and searchable. On resume, search BEFORE asking the user:

| Need                        | Command                                                                    |
| --------------------------- | -------------------------------------------------------------------------- |
| What were we working on?    | `ctx_search(queries: ["summary"], source: "compaction", sort: "timeline")` |
| What was the first request? | `ctx_search(queries: ["prompt"], source: "user-prompt", sort: "timeline")` |
| What did we decide?         | `ctx_search(queries: ["decision"], source: "decision", sort: "timeline")`  |
| What NOT to repeat?         | `ctx_search(queries: ["rejected"], source: "rejected-approach")`           |
| What constraints exist?     | `ctx_search(queries: ["constraint"], source: "constraint")`                |

DO NOT ask "what were we working on?" — SEARCH FIRST.
If search returns 0 results, proceed as a fresh session.

## ctx commands

| Command       | Action                                                                            |
| ------------- | --------------------------------------------------------------------------------- |
| `ctx stats`   | Call `ctx_stats` MCP tool, display full output verbatim                           |
| `ctx doctor`  | Call `ctx_doctor` MCP tool, run returned shell command, display as checklist      |
| `ctx upgrade` | Call `ctx_upgrade` MCP tool, run returned shell command, display as checklist     |
| `ctx purge`   | Call `ctx_purge` MCP tool with confirm: true. Warns before wiping knowledge base. |

After /clear or /compact: knowledge base and session stats preserved. Use `ctx purge` to start fresh.

## Subagent Model Routing

Default session model: `sonnet` (Claude Sonnet 4.6), pinned in `settings.json` (`"model": "sonnet"`). Claude Code selects subagent model from agent-definition frontmatter (`model:` = `inherit` | `opus` | `sonnet` | `haiku` | `<api-id>`), NOT via per-call `model:` override on the `Task` tool. Reviewed 2026-06-29 against [Models overview](https://platform.claude.com/docs/en/about-claude/models/overview) + [Fable/Mythos intro](https://platform.claude.com/docs/en/about-claude/models/introducing-claude-fable-5-and-claude-mythos-5).

### Available models (3 only)

| Model             | API ID              | $/in MTok | $/out MTok |  ctx | max out | extended thinking | adaptive thinking (effort) | latency  |
| ----------------- | ------------------- | --------: | ---------: | ---: | ------: | :---------------: | :------------------------: | -------- |
| Claude Opus 4.8   | `claude-opus-4-8`   |        $5 |        $25 |   1M |    128k |         ✗         |    ✓ (defaults `high`)     | moderate |
| Claude Sonnet 4.6 | `claude-sonnet-4-6` |        $3 |        $15 |   1M |    128k |         ✓         |             ✓              | fast     |
| Claude Haiku 4.5  | `claude-haiku-4-5`  |        $1 |         $5 | 200k |     64k |         ✓         |             ✗              | fastest  |

All 3: vision ✓, native tool-use / JSON ✓, multilingual ✓.

### Cost ranking (cheapest→dearest)

1. **Haiku 4.5** — $1/$5, 200k ctx, fastest. No effort-tune; skip for deduction-heavy work.
2. **Sonnet 4.6** — $3/$15, 1M ctx, fast. Effort-tunable + extended thinking. ~3× cheaper than Opus on output. Best speed/intelligence combo.
3. **Opus 4.8** — $5/$25, 1M ctx, moderate. Effort-tunable; NO extended thinking (uses adaptive thinking instead). Most capable; high-autonomy agentic coding.

### NOT available (do not use)

- **Claude Fable 5** (`claude-fable-5`) — available again in this environment as of 2026-07-14 (for now — provisional, re-check before relying on it long-term).
- **Claude Mythos 5** (`claude-mythos-5`) — limited availability, Project Glasswing invitation-only. Do not reference.
- If Mythos becomes available, re-fetch docs + update this section.

### USER OVERRIDE (2026-09-29) — supersedes routing table + pins below

- **opus**: all coding + review (`worker`, `review`, `oracle`, `cleanup` when non-trivial).
- **sonnet**: testing, scouting, research, small/low-complexity tasks, low-complexity coding (`tester`, `scout`, `docs`, `commit`).
- **Thinking effort** scales with complexity: low = mechanical/lookup, medium = standard impl/test, high = design, cross-file, security, root-cause. Agent frontmatter `effort:` sets default (worker/review/oracle `high`, tester/scout `low`, docs `medium`); raise/lower per dispatch in the prompt.
- Dispatch-plan gate stays: list agent + model + effort, wait for OK.

### Routing table

| Role                                                              | Agent(s)                                    | Model                                | Why                                                                                                      |
| ----------------------------------------------------------------- | ------------------------------------------- | ------------------------------------ | -------------------------------------------------------------------------------------------------------- |
| Orchestrator (main)                                               | —                                           | `sonnet`                             | 1M ctx headroom for accumulating subagent returns; effort-tune. Pinned in `settings.json`.               |
| Worker: code-heavy / general fork (default)                       | `worker` (create); repin `cleanup`, `docs`  | `sonnet`                             | Best speed/intelligence; 1M ctx; effort-tune + extended thinking. ~3× cheaper than Opus on output.       |
| Mechanical / test scaffold / recon / handoff                      | `scout` (create); `commit`                  | `haiku`                              | Cheapest + fastest; vision + tool-use. No adaptive thinking — skip for deduction.                        |
| Analysis / review (standard)                                      | `review`, `oracle`                          | `sonnet`                             | Parallel sub-agents need breadth + 1M ctx; effort-tune for adversarial angles.                           |
| Deep-dive / long-horizon / security-critical / large blast-radius | one-off                                     | `opus`                               | Highest capability; high-autonomy agentic coding. Override UP from `sonnet` when pattern-matching fails. |
| Screenshot / vision / JSON handoff                                | simple→`haiku`, complex→`sonnet`            | `haiku`/`sonnet`                     | All models have vision+json; Haiku for mechanical capture, Sonnet for interpretation.                    |
| Test runner / invoke + parse / summarize                          | `tester` (create); no subagent if just Bash | `haiku`                              | Tool-use + code execution; mechanical invoke→parse→report. No deduction needed.                          |
| Test authoring from clear spec                                    | `tester`                                    | `haiku`                              | Spec-driven boilerplate + assertions.                                                                    |
| Test authoring w/ edge-case / concurrency reasoning               | `tester`                                    | `sonnet`                             | Needs reasoning Haiku lacks (no adaptive thinking). Escalate from `haiku` if scaffolds miss edges.       |
| Failure root-cause diagnosis (test fail)                          | `tester`→`review`                           | `sonnet` (override `opus` if subtle) | Deduction required. Escalate to `opus` when pattern-matching fails or bug is subtle/security-critical.   |

### Escalation tiers (cost-ordered, pre-authorized)

1. Driver / mechanical: `haiku` ($1/$5)
2. Diagnosis: `sonnet` ($3/$15, adaptive thinking on)
3. Deep: `opus` ($5/$25, effort-tune)

A task escalating haiku→sonnet→opus within these tiers = pre-authorized (just log, no re-confirm).

### Per-agent pin mechanism (Claude Code)

Claude Code picks model from agent-definition frontmatter. To pin a model: edit `~/.claude/<agent>.md`, set `model: <opus|sonnet|haiku|<api-id>>`. Use `model: inherit` to follow session default (`sonnet`).

Current agent pins (updated 2026-06-29):

| Agent     | Model    | Reason                                       |
| --------- | -------- | -------------------------------------------- |
| `commit`  | `haiku`  | Mechanical diff→message, no deduction needed |
| `cleanup` | `sonnet` | Code-aware, effort-tuneable, 3× cheaper      |
| `docs`    | `sonnet` | Code-aware, effort-tuneable, 3× cheaper      |
| `review`  | `sonnet` | Parallel sub-agents, breadth + 1M ctx        |
| `oracle`  | `sonnet` | Adversarial, breadth + 1M ctx                |
| `worker`  | `sonnet` | Code-heavy impl, effort-tune + thinking      |
| `scout`   | `haiku`  | Read-only recon, cheapest + fastest          |
| `tester`  | `haiku`  | Mechanical invoke→parse→report               |

Override `review`/`oracle` to `opus` per-dispatch for security-critical or subtle bug diagnosis.

### Orchestration discipline

1. Never ingest raw subagent dumps — use `ctx_batch_execute` / `ctx_search` indirection.
2. Freeze orchestrator system prompt + plan across turns → prompt caching.
3. Spawn one-shot `sonnet`/`haiku` for vision/JSON jobs (Opus fine too — all have vision); return summary to orchestrator.
4. Watch `ctx stats`; if hitting limits, reduce fan-out / compress returns.
5. **NEVER use `subagent_type: "claude"` for work tasks.** That is the generic agent and always runs at opus (session default). Always map to a named agent from the table below. If no named agent fits, create a throwaway agent def with the right `model:` pin.

### When to auto-dispatch (no confirmation needed)

Fan out to subagents automatically when the task matches. **Always use the named `subagent_type`.**

| Trigger                                                    | subagent_type | Model   |
| ---------------------------------------------------------- | ------------- | ------- |
| Task touches **3+ files** to implement/refactor/fix        | `worker`      | sonnet  |
| Write spec / design doc / plan for a feature               | `worker`      | sonnet  |
| Code review of diff or files                               | `review`      | sonnet  |
| Adversarial challenge / "what could go wrong"              | `oracle`      | sonnet  |
| Locate symbols / map files / "where is X"                  | `scout`       | haiku   |
| Write commit message                                       | `commit`      | haiku   |
| Run or write tests                                         | `tester`      | haiku   |
| Diagnose failing / flaky tests, root-cause investigation   | `review`      | sonnet  |
| Clean up code / remove slop                                | `cleanup`     | sonnet  |
| Add or generate docs                                       | `docs`        | sonnet  |

For parallel fan-out batches, announce which agents you're spawning inline (one line), then spawn — no gate.

### Model confirmation before dispatch — HARD GATE (temporary)

**ALWAYS stop and show dispatch plan before spawning any subagent. Wait for explicit user confirmation.**

```
Dispatch plan:
  agent: <name>  model: <haiku|sonnet|opus>  reason: <one line>
Proceed?
```

For parallel fan-out batches, list all agents in one block, then wait for a single confirmation before spawning any.

Do NOT auto-fire. Do NOT skip this gate. Regardless of role defaults or tier escalations — always ask first.

### Ad-hoc Task spawns (no matching agent)

`Task` tool takes `subagent_type` only; model follows that agent's frontmatter. For one-offs with no fit:

1. Prefer nearest existing agent with correct `model:` pin.
2. If none, create a throwaway agent def (`~/.claude/agents/<role>-oneshot.md`) with the right `model:`, dispatch, delete after.

### Known stale / unavailable

- `claude-fable-5` — available again as of 2026-07-14 (provisional). `claude-mythos-5` — still NOT available. Re-check quarterly.

### Review cadence

Quarterly; or after any model deprecation / new-model GA / re-fetching the [Models overview](https://platform.claude.com/docs/en/about-claude/models/overview).

## Shell scripts — zsh pitfalls (MANDATORY)

The Bash tool runs zsh. It does NOT word-split unquoted variables and it errors on unmatched globs. Seen too often (az calls all failed, "created" still printed).

- Never put CLI args in a string variable (`Z="-g rg -z zone"; az ... $Z`). Use `bash -c '...'` with an array (`Z=(-g rg -z zone); az ... "${Z[@]}"`) or write the args out.
- Quote globs/brackets (`'custom-columns=...[0]'`, `'*.foo'`); unmatched ones abort in zsh.
- `set -e` + a trailing `echo done` proves nothing. Verify the result (read it back) before reporting success, and never report "created/done" from an echo.
- Multi-step scripts: run under `bash -c` with `set -euo pipefail`, then read back state.

## After every merge: worktree and Jira ticket (MANDATORY)

After each merge request I merge (or set to auto-merge and see merged), do both without asking:
1. **Worktree:** if a git worktree exists for the merged branch (`git worktree list`) and it is clean and fully merged, remove it (`git worktree remove`) and delete the local branch. Keep it when there is an open MR on it, uncommitted changes, or it is still in use.
2. **Jira:** if the MR names a ticket (key in branch name, MR title or description, e.g. `DEVOPS-123`, `PAS-123`) or the user gave one for this work, add a short comment (1-3 lines: what merged, MR number, what is open) to keep it current. Do not close or transition the ticket without asking. No ticket given or found: skip, do not ask.

Do this once per merge batch, not after every single MR of a stack.
