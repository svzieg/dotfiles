# Code Review

Review the current config diff for correctness, regressions, and maintainability.

1. Run `config diff` to see unstaged changes, or `config diff --cached` for staged changes
2. Review each change for:
   - **Correctness bugs** — logic errors, off-by-one, missing null checks
   - **Regressions** — will this break existing behavior?
   - **Simplicity** — can this be done with less code?
   - **Security** — injection, auth bypass, data leaks
3. For each finding, provide: file:line, severity (critical/warning/nit), and a concrete fix suggestion
4. Output format: one line per finding, terse

$ARGUMENTS