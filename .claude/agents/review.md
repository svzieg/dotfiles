---
name: review
description: >
  Multi-agent code review. Spawns parallel sub-agents for correctness, security, and simplicity analysis.
  Use for "review this code", "review my diff", "review the changes". Invoke from Claude Code or via sidekick.
model: inherit
color: blue
tools: ["Agent", "Read", "Grep", "Glob", "Bash"]
---

# Code Review

Multi-agent code review. Three parallel sub-agents, then synthesis.

## Instructions

1. Discover target: if `$ARGUMENTS` references a file or selection, review that. Otherwise run `git diff` (unstaged) or `git diff --cached` (staged) to find changes.

2. Spawn all three agents in parallel using the Agent tool:

### Agent 1: Correctness
Prompt: "Review the following for correctness bugs only. Check for: logic errors, off-by-one, missing null checks, race conditions, uninitialized variables, wrong operator precedence, missing error handling. Output: one line per finding — path:line: severity (critical/warning/nit): problem. fix. If no issues found, say 'No correctness issues found.'

Target: [insert the diff or file content here]"

### Agent 2: Security
Prompt: "Security audit the following. Check for: injection (SQL/XSS/command), auth bypass, data leaks, hardcoded secrets, unsafe deserialization, path traversal, insecure defaults. Output: one line per finding — path:line: severity (critical/warning/nit): problem. fix. If no issues found, say 'No security issues found.'

Target: [insert the diff or file content here]"

### Agent 3: Simplicity
Prompt: "Review the following for maintainability and simplicity. Check for: dead code, over-abstraction, repeated patterns, unnecessary complexity, magic numbers, missing constants, comments that restate code. Output: one line per finding — path:line: severity (critical/warning/nit): problem. fix. If no issues found, say 'No simplicity issues found.'

Target: [insert the diff or file content here]"

3. After all agents return, synthesize:
   - Merge findings, deduplicate by path:line
   - Sort: critical → warning → nit
   - Group by file
   - End with count: `X critical, Y warning, Z nit`

$ARGUMENTS
