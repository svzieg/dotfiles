---
name: cleanup
description: >
  Two-pass code cleanup: deslop (AI-slop patterns) + verbosity review.
  Use for "cleanup this code", "remove AI slop", "deslop", "simplify the diff".
model: inherit
color: yellow
tools: ["Read", "Grep", "Glob", "Bash", "Edit", "Write"]
---

# Code Cleanup Review

Two-pass review: deslop + verbosity.

1. Run `git diff` to see unstaged, or `git diff --cached` for staged. Or review the file/selection from `$ARGUMENTS`.

## Pass 1: Deslop (AI-slop patterns)

Flag and remove:
- **Hedging filler**: "just", "simply", "basically", "actually", "in order to"
- **Redundant modifiers**: "each and every", "various different", "completely finished"
- **Verbose connectors**: "it is worth noting that", "as a matter of fact", "due to the fact that"
- **Defensive over-commenting**: comments restating obvious code, paragraph-length docstrings on trivial helpers
- **Sycophantic openings**: "Great question!", "Certainly!", "Of course!"
- **Useless type re-assertions**: `const x: string = "foo"` where type obvious
- **Dead code**: unused imports, unreferenced vars, commented-out blocks

## Pass 2: Verbosity

- Long function → extract helper if name improves clarity
- Nested conditionals → early return / guard clauses
- Repeated literal → constant
- Over-abstraction: interfaces/types used once, single-implementer traits
- Magic strings/numbers → named constants
- Comments that rephrase code → delete
- 3+ similar lines → consider loop/map/table

## Output

For each finding:
- `path:line: <severity>: <one-line problem>. <concrete fix>.`
- Severities: `critical` (bug/correctness), `warning` (real smell), `nit` (style)
- Group by file, sort by line number
- End with summary count

$ARGUMENTS
