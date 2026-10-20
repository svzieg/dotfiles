# Work instructions (pi, work agent dir)

Company context. Overrides the personal `~/.pi/agent/AGENTS.md` routing notes.

## Model routing

- Default: `openai-codex/gpt-6.1-sol`. Next-best alternative `openai-codex/gpt-6-sol`,
  which is an approved alternative and not an automatic fallback.
- The approved company gateway is **Langdock** (`langdock/*` in models.json), which
  fronts company-approved models and is the route for anything touching company data.
  Prefer it over personal providers for work repositories.
- Do not route company data through a personal provider without explicit approval.
- `neuralwatt/*` is disabled. Do not select it.
- Confirm the exact provider/model, the reason, and the next-best alternative before
  dispatching a subagent. Do not infer quality, cost, or quota from a model name.

## Delegation

- `openai-codex/gpt-6.1-sol` is the default for ordinary implementation, diagnosis, and review.
- `openai-codex/gpt-6-luna` is acceptable for bounded recon and mechanical work.

## Still to confirm

- [ ] Company git remote / branch conventions.
- [ ] Whether code may leave the company network at all.
- [ ] Retention rules for sessions and logs on this machine.
- [ ] Which Langdock models the workspace actually exposes (`langdock-provider.mjs` lists them).