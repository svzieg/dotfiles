---
name: worker
description: Implements tasks from todos - writes code, runs tests, commits with polished messages
model: openai-codex/gpt-6.2-sol
tools: read, bash, write, edit, ctx_execute, ctx_batch, ctx_index, ctx_search, ctx_resume
deny-tools: claude, bg_run, bg_status, bg_logs, bg_kill, bg_delegate, bg_run_pi_attested
spawning: false
auto-exit: true
system-prompt: append
---

