# Work instructions (pi, work agent dir)

Company context. Overrides the personal `~/.pi/agent/AGENTS.md` routing notes.

## Model routing

- Prefer company-approved Claude and/or Codex accounts and routes for coding.
  Langdock is no longer available for company coding; do not recommend it.
- Keep the existing configured default until Claude Code is authenticated and the
  available model catalog has been verified. Do not silently switch accounts or routes.
- Personal-subscription models are allowed for eligible public/OSS and other tasks
  that do not require company privacy restrictions. Classify the supplied context,
  not just the repository: public source can still be discussed alongside internal data.
- Never send company-restricted conversation history, internal notes, or retrieved
  context to a personal route. Switching models in an existing session retains history.
- `neuralwatt/*` is enabled following the privacy review and the user's explicit
  approval. Apply the same context, account, and privacy checks as for other providers;
  do not impose a blanket Neuralwatt-specific ban.
- Confirm the exact authenticated provider/model, the reason, and the next-best
  alternative before dispatching a subagent. Do not infer quality, cost, or quota
  from a model name.

## Tooling

- **Surface choice:** three tools overlap; pick by what the step is, not by
  habit. The context-mode hint ("use `ctx_execute` for >20 lines of data")
  does not override this section.
  - `codemode` (JS): the default when there are **two or more independent
    calls** (reads, greps, Jira/`twg` lookups, several kubectl queries), or
    when the result needs filtering, joining or comparing across calls. It
    reaches every tool via `tools.*`, including `tools.bash` and
    `tools.ctx_execute`, so run the calls in parallel (`Promise.allSettled`)
    and return only the findings. It has no filesystem or shell of its own and
    cancels pending calls when the script returns.
  - `ctx_execute`: one local script that needs a real runtime (shell pipeline,
    Python/Node parsing of a big file or JSON dump) and whose raw output is
    large. Only the printed answer reaches the conversation, and the full
    output is indexed for `ctx_search`. Inside a `codemode` script, call it as
    `tools.ctx_execute` when one step of a batch needs this.
  - `bash`: processes, long or background jobs, and file mutation (git, edits,
    `kubectl apply`/`annotate`). Keep its output small; for large output use
    `ctx_execute` instead of piping to `/tmp` files and re-reading them.
  - A single small command: just run it with `bash`; no wrapper needed.
  - Reach for a python heredoc only for mechanical multi-file patches where
    every replacement is asserted (`count == 1`).

## Delegation

- Dedicated work and eligible-personal worker/reviewer agents are allowed in this
  profile. Configure their exact models after checking the authenticated catalog;
  do not invent or assume model IDs.
- Work agents use company-approved routes and may receive relevant work context.
- Personal/public-task agents start standalone with an explicitly bounded task and
  eligible files, without inherited work turns. Do not fork a restricted conversation
  or automatically search mixed project memory for these agents.
- Selecting a model does not itself select a different account, configuration, or
  memory store. Verify the actual route before using it.

## Still to confirm

- [ ] Company git remote / branch conventions.
- [ ] Which Claude/Codex accounts and data-handling terms apply to company-restricted work.
- [ ] Retention rules for sessions and logs on this machine.
- [ ] Exact authenticated models for the work and eligible-personal worker/reviewer agents.