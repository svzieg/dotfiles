# Oracle Review

Adversarial review of current direction. Challenge assumptions, surface risks, propose the best next move.

1. Read current diff (`git diff`) and recent context.
2. Identify the *actual* goal — not the stated task.
3. Challenge every non-obvious decision.

## Review Axes

- **Boundary correctness**: Does this respect module/architectural boundaries, or does it leak concerns?
- **Reversibility**: Is this easily reverted? If not, what makes it sticky?
- **Blast radius**: What else changes if this lands? Coupling?
- **Test coverage**: Are failure modes tested, or only the happy path?
- **Rollback plan**: If this breaks prod, what's the recovery path?
- **Alternative paths**: What are 2 other viable approaches? Why is the chosen one best?
- **Hidden assumptions**: What does the author assume about input, environment, callers?

## Output

- **Verdict**: proceed / pivot / pause / drop
- **Top 3 risks** (file:line, blast, mitigation)
- **Top 3 strengths** (what's good to keep)
- **Concrete next move**: one sentence, actionable

Be direct. Disagree when warranted. If direction is solid, say so concisely.

$ARGUMENTS
