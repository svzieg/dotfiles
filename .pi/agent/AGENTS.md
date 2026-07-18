# context-mode — MANDATORY routing rules

context-mode MCP tools available. Rules protect context window from flooding. One unrouted command dumps 56 KB into context. Pi enforces routing via hooks (`tool_call` blocks `curl`/`wget`) AND these instructions. Hooks = hard enforcement; rules = completeness for redirections hooks cannot catch.

## Think in Code — MANDATORY

Analyze/count/filter/compare/search/parse/transform data: **write code** via `ctx_execute(language, code)`, `console.log()` only the answer. Do NOT read raw data into context. PROGRAM the analysis, not COMPUTE it. Pure JavaScript — Node.js built-ins only (`fs`, `path`, `child_process`). `try/catch`, handle `null`/`undefined`. One script replaces ten tool calls.

## BLOCKED — do NOT use

### curl / wget — FORBIDDEN (hook-enforced)

Do NOT use `curl`/`wget` in `bash`. Pi hooks block these. Dumps raw HTTP into context.
Use: `ctx_fetch_and_index(url, source)` or `ctx_execute(language: "javascript", code: "const r = await fetch(...)")`

### Inline HTTP — FORBIDDEN

No `node -e "fetch(..."`, `python -c "requests.get(..."`. Bypasses sandbox.
Use: `ctx_execute(language, code)` — only stdout enters context

### Direct web fetching — FORBIDDEN

Raw HTML can exceed 100 KB.
Use: `ctx_fetch_and_index(url, source)` then `ctx_search(queries)`

## REDIRECTED — use sandbox

### bash (>20 lines output)

`bash` ONLY for: `git`, `mkdir`, `rm`, `mv`, `cd`, `ls`, `npm install`, `pip install`.
Otherwise: `ctx_batch_execute(commands, queries)` or `ctx_execute(language: "shell", code: "...")`

### read (for analysis)

Reading to **edit** → `read` correct. Reading to **analyze/explore/summarize** → `ctx_execute_file(path, language, code)`.

### grep / find (large results)

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

## Output

Write artifacts to FILES — never inline. Return: file path + 1-line description.
Descriptive source labels for `search(source: "label")`.

## Session Continuity

Skills, roles, and decisions persist for the entire session. Do not abandon them as the conversation grows.

## Memory

Session history is persistent and searchable. On resume, search BEFORE asking the user:

| Need                    | Command                                                                   |
| ----------------------- | ------------------------------------------------------------------------- |
| What did we decide?     | `ctx_search(queries: ["decision"], source: "decision", sort: "timeline")` |
| What constraints exist? | `ctx_search(queries: ["constraint"], source: "constraint")`               |

DO NOT ask "what were we working on?" — SEARCH FIRST.
If search returns 0 results, proceed as a fresh session.

## ctx commands

| Command       | Action                                                                        |
| ------------- | ----------------------------------------------------------------------------- |
| `ctx stats`   | Call `stats` MCP tool, display full output verbatim                           |
| `ctx doctor`  | Call `doctor` MCP tool, run returned shell command, display as checklist      |
| `ctx upgrade` | Call `upgrade` MCP tool, run returned shell command, display as checklist     |
| `ctx purge`   | Call `purge` MCP tool with confirm: true. Warns before wiping knowledge base. |

After /clear or /compact: knowledge base and session stats preserved. Use `ctx purge` to start fresh.

## Devcontainer kubeconfig — CRITICAL (DO NOT MODIFY)

- The project mounts `.devcontainer/.kube/` (host-local) to `/root/.kube` inside the devcontainer for cluster access (k3d / cluster-setup scripts).
  - **Mount source**: `${localWorkspaceFolder}/.devcontainer/.kube`
  - **Mount target**: `/root/.kube` (inside container)
  - **Contents**: kubeconfig, k3d certificates, cache files (managed by k3d and cluster-setup.sh)
- THIS FOLDER IS CRITICAL. Do NOT remove, delete, rename, recursively chmod, or otherwise mutate any files under `.devcontainer/.kube` without explicit user consent and an explicit step-by-step plan.
- In particular, do NOT remove or garbage-collect `.devcontainer/.kube/cache` or `.devcontainer/.kube/config` on the host. These are necessary for devcontainer cluster setup and for the host to access the cluster inside the devcontainer.
- If you encounter permission issues related to files inside `.devcontainer/.kube` (e.g., owned by `root`), DO NOT perform host-side destructive fixes. Instead:
  1. Ask the user for permission to act. Explain the risk and the exact commands you will run.
  2. Prefer running repairs from *inside* the devcontainer (e.g., `devcontainer exec` or postStart scripts) where the process has the correct context and ownership, or instruct the user to run the operation locally.
  3. When automated fixes are necessary, keep them minimal and reversible (do not `rm -rf` the directory); prefer adjusting mount flags or devcontainer startup scripts to set proper file modes (for example, `cluster-setup.sh` may `chmod 0644` the generated kubeconfig so the host user can read it).
- Agents MUST record a decision/event when they touch any `.devcontainer/.kube` content (use `ctx_index` / `ctx_search` with a `decision`/`error` event) so the action is discoverable later.

AGENT-CONTRACT: PROTECT_PROJECT_KUBECONFIG — Any automated agent or helper must not mutate or remove `.devcontainer/.kube` or its contents unless explicitly authorized by the user in a follow-up message. This rule persists across sessions.

---

## Subagent Model Routing

Default session model: `neuralwatt/glm-5.2`. Pinning builtins needs a user-scope same-name override; prefer per-call `model:`. Reviewed 2026-06-27 against live `api.neuralwatt.com/v1/models` (11 models). **Billing = energy-based, flat $5.00/kWh** (not per-token); cost below is $/req = Wh × $5.

### Cost ranking (cheapest→dearest, 7-day avg Wh/req)

| Model | Wh/req | $/req | ctx | reason | effort | json | vision |
|---|---:|---:|---:|:--:|:--:|:--:|:--:|
| qwen3.6-35b-fast | 46 mWh | $0.00023 | 131K | off | – | ✓ | ✓ |
| qwen3.6-35b | 152 mWh | $0.00076 | 131K | on | – | ✓ | ✓ |
| qwen3.5-397b-fast | 294 mWh | $0.00147 | 262K | off | – | ✓ | ✗ |
| qwen3.5-397b | 303 mWh | $0.00152 | 262K | on | – | ✓ | ✗ |
| glm-5.2-short-fast | 444 mWh | $0.00222 | 200K | off | ✓ | ✗ | ✗ |
| kimi-k2.6-fast | 566 mWh | $0.00283 | 262K | off | – | ✓ | ✓ |
| glm-5.2-fast | 634 mWh | $0.00317 | 1M | off | ✓ | ✗ | ✗ |
| kimi-k2.6 | 793 mWh | $0.00396 | 262K | on | – | ✓ | ✓ |
| glm-5.2-short | 1320 mWh | $0.00660 | 200K | on | ✓ | ✗ | ✗ |
| kimi-k2.7-code | 1710 mWh | $0.00855 | 262K | on | – | ✓ | ✓ |
| glm-5.2 | 2260 mWh | $0.01130 | 1M | on | ✓ | ✗ | ✗ |

**Key facts:** GLM-5.2 family = ONLY models with tunable `reasoning_effort`; GLM has NO json/vision. Within GLM family the `-short` variants ARE significantly cheaper: short = 42% off full (1.32 vs 2.26 Wh), short-fast = 80% off (444 mWh). But **Qwen3.6-35B family still 3–9× cheaper than even GLM-short on energy** → Qwen dominates subagent tier. GLM needed only where effort-tuning or 1M ctx required. GLM labeled "test canary / grant-gated private preview" → access-fragile; fallback = `kimi-k2.7-code`.

### Routing table (energy-aware)

| Role | Agent(s) | Model | Why |
|---|---|---|---|
| Orchestrator (main) | — | `neuralwatt/glm-5.2` (1M) | Only effort-tuning + 1M headroom for accumulating subagent returns. Freeze prompt+plan (cached_input lever). NO vision/json → delegate those jobs. Fallback if grant lost: `kimi-k2.7-code`. |
| Worker: code-heavy fork (default) | `worker` | `neuralwatt/glm-5.2-short` | Benchmarks (vendor-reported): GLM-5.2 beats Kimi K2.7-Code on SWE-bench Pro (62.1 vs ~58.6) + Terminal-Bench 2.1 (81.0 vs ~71.0) + planning (9.0 vs 8.1). Short variant = 200K + bounded reasoning budget. 1320 mWh — actually CHEAPER than kimi-k2.7-code (1710 mWh) AND stronger pure-code. Has `reasoning_effort` tuning (GLM-only). NO json/vision → override for those. |
| Worker: non-code large-ctx reasoning / synthesis | `worker` | `neuralwatt/qwen3.5-397b` | 303 mWh, 262K, reasoning+json — for the slot where Kimi's code-specialization is wasted cost (docs analysis, structured transforms, non-code synthesis). |
| Worker: code-heavy fork + JSON handoff / screenshot / tool-chain agentic loop | `worker` | `neuralwatt/kimi-k2.7-code` | Override from glm-short. Kimi K2.7-Code wins MCP Mark Verified (81.1, agentic tool-use) + has json+vision+262K GLM shorts can't match. 1710 mWh. |
| Worker: code-heavy fork >200K ctx OR marathon long-horizon | `worker` | `neuralwatt/glm-5.2` | Override when scope exceeds 200K. Full GLM stronger than short on long-horizon (FrontierSWE trails Claude Opus 4.8 by 1%). 2260 mWh, 1M ctx. |
| Worker: mechanical / test scaffold | `worker` | `neuralwatt/qwen3.6-35b` | 152 mWh, reasoning on, vision+json. Use `-fast` (46 mWh) when no deduction. |
| Recon / handoff / context prep | `scout`, `delegate`, `context-builder` | `neuralwatt/qwen3.6-35b-fast` | 46 mWh — cheapest; vision+json; no wasted reasoning. |
| Analysis / review | `reviewer`, `oracle`, `planner` | `neuralwatt/qwen3.6-35b` (151 mWh, ≤131K scope) | Override to `kimi-k2.6` (793 mWh, 262K, vision+json) when ctx > 131K or structured/PR-visual review. Override to `glm-5.2` only for deep multi-source synthesis needing effort-tune + >262K. Frontier-model override for one-off SEC-class reviews if budget allows. |
| Research | `researcher` | `neuralwatt/kimi-k2.6` | 793 mWh, 262K, vision+json+reasoning — breadth + extraction. Override down to `qwen3.6-35b` for scoped <131K research. |
| Browser testing loop | `worker` | `neuralwatt/qwen3.6-35b-fast` | 46 mWh, mechanical selector+DOM+assert. |

### Browser-test escalation (3 tiers, energy-ordered)

1. Driver: `qwen3.6-35b-fast` (46 mWh, no reasoning).
2. Diagnosis: `qwen3.6-35b` (152 mWh, reasoning on).
3. Deep: `kimi-k2.6` (793 mWh, 262K, vision+json) first — cheaper than glm-short AND fills GLM's gaps; only escalate to `glm-5.2-short`/`glm-5.2` when effort-tune needed.

### Orchestration discipline

1. Never ingest raw subagent dumps — use `ctx_batch_execute`/`ctx_search` indirection.
2. Freeze orchestrator system prompt + plan across turns → cached_input.
3. GLM has no vision/json → spawn one-shot `kimi-k2.6` or `qwen3.6-35b` for screenshot/JSON jobs; return summary to orchestrator.
4. GLM is grant-gated/canary; `kimi-k2.7-code` is graceful-degradation fallback.
5. Watch `ctx stats`; if hitting limits, reduce fan-out / compress returns.

### Per-call override syntax

`subagent({ agent: "reviewer", model: "<provider>/<model>", ... })`.

**Override upward (frontier):** one-off security-critical review; long-blast-radius architecture; subtle-bug diagnosis where pattern-matching fails.
**Override downward:** mechanical multi-file refactor; test scaffolding w/ clear spec; bulk recon over large codebases.

### Model confirmation before dispatch — MANDATORY

Orchestrator MUST surface model choice + WAIT for confirmation before spawning subagents. Silent routing to a non-default model = routing violation.

```
Dispatch plan:
  - role / agent: <agent>
  - model: <provider>/<model>      # e.g. neuralwatt/qwen3.5-397b
  - reason: <one line why this, not default>
  - alt considered: <next-best, one line why rejected>
Proceed? (y / pick other / adjust scope)
```

- One confirmation covers a parallel fan-out batch IF all use role defaults (no override, no up/down pin) — list agents + default models compactly.
- ANY per-call `model:` override (up or down) or non-default agent = own explicit confirmation.
- Pre-authorized models (recorded as `decision` via `ctx_index`/`ctx_search`) reusable without re-confirm, but restate model inline.
- Loop escalations (browser 3-tier) pre-authorized by table — just log, no re-confirm.
- Unsure → ASK.

### Known stale / fragile models

- `nano-gpt/xiaomi/mimo-v2.5`, `nano-gpt/xiaomi/mimo-v2.5-pro` — 402 insufficient balance (2026-06-24). Do not use.
- `neuralwatt/glm-5.2` (+ all GLM variants) — "test canary" + "grant-gated private preview". Fallback if grant revoked: `kimi-k2.7-code`.

### Review cadence
    
Quarterly; or after any 402/failure/grant-revoke; or after re-fetching `api.neuralwatt.com/v1/models` + `portal.neuralwatt.com/energy-pricing` (Wh/req is 7-day trailing, refresh quarterly). `pi.dev/v1/models` returned HTTP 522 on 2026-06-27 — neuralwatt endpoints = source of truth.
    
---
    
## Subagent Delegation Discipline
    
Parent session = COORDINATOR, not default executor. Thin conversation thread, delegate real work to subagents when complexity appears, synthesize results. Keep one writer per cwd/worktree unless isolated worktrees explicitly approved.
    
### Language Boundary
    
Subagent-facing delegation prompts = English by default, even when user speaks Spanish. Translate request into concise English before delegation. Lower token usage, consistent operating language. Exceptions: preserve exact user quotes, UI copy, error messages, filenames, commands, domain terms in original language as evidence. Ask subagent for Spanish output only when result pasted directly to user / Spanish PR-comment / Spanish product text.
    
### Work Routing Ladder
    
Route work through smallest safe harness:
    
**1. Inline Direct** — small, mechanical, parent already has context (typo, one-file mechanical edit, 1-3 file verification, bash for state `git status`/`gh issue view`). No ceremony. Do not delegate to look sophisticated. Do not hide behind this once task stops being small.
    
**2. Simple Delegation** — inflates parent context, or needs focused exploration/validation/multi-file implementation, short of full lifecycle. Prefer `subagent`/`subagent_*` tools when pi-subagents installed (runs configured project/global subagent defs, preserves history/background). Fallback to native `Agent` tool if unavailable — delegation stays mandatory, only runtime changes.
    
Subagent mode by orchestration dependency, not task length: `mode: "task"` when parent must consume result + continue workflow; `mode: "background"` only for independent work where parent continuation not required.
    
**3. Project-defined lifecycle** (SDD or equivalent) — for large/ambiguous/architectural/product-facing/multi-area/high-review-risk work, OR explicit project AGENTS.md /user request. Use project-mandated artifact schema + status engine; do NOT impose this AGENTS.md's lifecycle on projects that define their own.
    
### Delegation Rules
    
Core question: does this inflate parent context without need?
    
| Action | Inline | Delegate |
|---|---:|---:|
| Read to decide/verify 1-3 files | yes | no |
| Read to explore/understand 4+ files | no | yes |
| Read as prep for multi-file writing | no | yes |
| Write atomic one-file mechanical change | yes | no |
| Write with analysis across multiple files | no | yes |
| Bash for state (git status) | yes | no |
| Bash for execution (tests/builds) | no | yes |
| Commit/push/PR after code changes | no | yes, fresh review first |
| Recover from wrong cwd/worktree/git/tooling incident | no | yes, fresh audit first |
    
### Mandatory Delegation Triggers (stop rules)
    
Once fired, delegate through best available subagent runtime. Do not replace required delegation with inline execution. If no delegation mechanism available, stop + explain blocker.
    
1. **4-file rule** — understanding requires reading 4+ files → launch `scout`/`context-builder`/read-only mapper with fresh context + narrow mapping task.
2. **Multi-file write rule** — implementation touches 2+ non-trivial files → delegate one writer; inline only for trivial/mechanical. Fresh review follows.
3. **PR rule** — before commit/push/PR for code changes, fresh-context review lens unless trivial docs/text-only diff.
4. **Incident rule** — after wrong cwd/worktree mutation/failed merge/bad tooling → stop + fresh audit through relevant review lens before continuing.
5. **Long-session rule** — ~20 tool calls, 5 exploratory reads, or 2 non-mechanical edits without delegation → pause + delegate remaining work.
6. **Fresh review rule** — fresh-context review lens subagents for adversarial review of diffs/conflicts/PR readiness/incidents. Continuity-oriented workers only for implementation needing inherited state.
    
### Cost + Context Balance
    
Prefer delegation when fresh context improves correctness more than token savings:
- `scout`/`context-builder` compresses broad repo exploration into short handoff instead of loading many files into parent.
- One `worker` = one writer thread. No parallel writers unless isolated worktrees explicitly approved.
- Fresh concrete review-lens agents after implementation/conflict resolution/incidents (value = independence from parent assumptions). Do NOT call generic `reviewer`; choose concrete lens (see below).
- `outputMode: "file-only"` for large child reports; summarize only decisions/blockers/paths in parent.
- Avoid delegation for truly local one-file fixes, quick state checks, already-understood mechanical edits.
    
### Review Lens Selection
    
`reviewer` = intent, not subagent name. Select concrete review agents by risk profile (review-*.md defs in `~/.pi/agent/agents/`):
    
| Context | Review lens |
|---|---|
| Clear naming/structure/maintainability/small refactors | `review-readability` |
| Behavior/state/tests/determinism/regressions | `review-reliability` |
| Shell/process integration/partial failures/recovery/degraded dependencies | `review-resilience` |
| Security/permissions/data exposure or loss/architecture/dependencies | `review-risk` |
| Large PR / hot path / >400 changed lines | Full 4R: risk → resilience → readability → reliability |
    
If multiple rows match, run narrow set covering the risk. Example: shell integration mutating live state → `review-reliability` + `review-resilience`, not `review-readability`.
    
### Canonical Lightweight Workflows
    
Bugfix with unfamiliar flow:
```text
parent git/status + clarify → scout fresh maps flow/files → parent decides → worker fork implements + tests → selected review lens audits diff → parent validates
```
    
Conflict / dependency-marker cleanup:
```text
parent reproduces/checks conflict → parent or worker resolves → selected review lens checks markers + package/lock consistency + repo cleanliness → parent reports/pushes
```
    
After tooling/worktree incident:
```text
stop writes → parent captures git status → selected review lens audits affected repos/worktrees NO edits → parent applies only confirmed recovery steps
```
    
### Safety
    
- Never commit unless user explicitly asks.
- Ask before destructive git operations, publishing, irreversible file changes.
- Keep writes single-threaded unless isolated worktrees explicitly approved.
- Preserve human control: user decisions beat agent momentum.
