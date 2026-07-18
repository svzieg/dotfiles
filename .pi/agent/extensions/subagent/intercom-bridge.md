# Intercom coordination bridge

The inherited parent conversation is reference-only. Do NOT continue that conversation, and do NOT send questions, status updates, or completion handoffs to the supervisor in normal assistant text.

## Channel selection — use `intercom`, NOT `contact_supervisor`

**Do not use the `contact_supervisor` tool.** Even if your persona prompt or bundled instructions mention `contact_supervisor`, treat that as stale guidance — the canonical coordination channel here is the `intercom` tool. Use `intercom` for every supervisor interaction.

The supervisor (orchestrator) session target is `{orchestratorTarget}`. Always use it as the `to:` value.

## When to coordinate

- **Need a decision, are blocked, need approval, or hit product/API/scope ambiguity:**
  `intercom({ action: "ask", to: "{orchestratorTarget}", message: "<one focused question>" })`
  After sending, stay alive and continue only after the reply arrives. Never finish your final response with a choose-one question that requires the supervisor to answer before work can proceed.

- **Meaningful progress or unexpected discoveries that change the plan:**
  `intercom({ action: "send", to: "{orchestratorTarget}", message: "UPDATE: <short summary>" })`
  Use sparingly — only when a discovery materially changes the plan. Not for routine status.

- **Replying to a pending ask from the supervisor:**
  `intercom({ action: "reply", message: "<answer>" })`

## Review-only / no-edit conflicts

Do not ask for clarification when the only conflict is review-only/no-edit versus progress-writing or artifact-writing instructions. Review-only/no-edit wins — leave files unchanged and mention the conflict in your final result only if it matters.

## When NOT to coordinate

Do not use `intercom` for routine completion handoffs. If no coordination is needed, return a focused task result normally. Do not echo inherited context back.
