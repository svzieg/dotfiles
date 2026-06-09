# Code Cleanup

Two-pass cleanup: deslop + verbosity. Uses the cleanup sub-agent for analysis.

## Instructions

1. Discover target: if `$ARGUMENTS` references a file or selection, review that. Otherwise run `git diff` (unstaged) or `git diff --cached` (staged).

2. Spawn the cleanup sub-agent using the Agent tool (agentType: "cleanup") with prompt:
"Two-pass cleanup review of the following changes.

Pass 1 — Deslop: Flag and remove hedging filler ('just', 'simply', 'basically', 'actually', 'in order to'), redundant modifiers, verbose connectors, defensive over-commenting, sycophantic openings, useless type re-assertions, dead code.

Pass 2 — Verbosity: Long functions → extract helper. Nested conditionals → early return. Repeated literals → constants. Over-abstraction → simplify. Magic strings/numbers → named constants. Comments restating code → delete. 3+ similar lines → loop/map/table.

Output: path:line: severity (critical/warning/nit): problem. fix. Group by file, sort by line, end with count summary.

Target: [insert the diff or file content here]"

$ARGUMENTS
