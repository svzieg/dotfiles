---
name: worker-docs
description: Documentation and language work - README/ADR prose, user-facing labels, i18n/translation pairs (de/en), API descriptions. Not for inventing report content or facts, money, schema or security changes.
model: openai-codex/gpt-6.1-terra
deny-tools: claude, bg_run, bg_status, bg_logs, bg_kill, bg_delegate, bg_run_pi_attested
spawning: false
auto-exit: true
system-prompt: append
---
