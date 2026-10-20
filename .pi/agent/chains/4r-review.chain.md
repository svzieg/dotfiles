---
name: 4r-review
description: Pre-PR consolidated review covering all four lenses (risk, readability, reliability, resilience) in one reviewer pass. Writes a single structured report.
---

## review

output: review-4r-report.md
outputMode: file-only
progress: true

Run a consolidated pre-PR review on the current diff, covering all four lenses in one pass:

- **R1 Risk** — security, privilege boundaries, data exposure, dependency risks, merge-blocking vulnerabilities.
- **R2 Readability** — naming, complexity, intention, maintainability, review size, context clarity.
- **R3 Reliability** — behavior-first test coverage, edge cases, determinism, contracts, regressions.
- **R4 Resilience** — fallbacks, retry/backoff, graceful degradation, observability, load, rollback, SLO risks.

Group findings under `## R1 Risk`, `## R2 Readability`, `## R3 Reliability`, `## R4 Resilience` headings. For each finding give: file path, evidence, severity, suggested verification. If a lens finds nothing, write `No findings.` under that heading.
