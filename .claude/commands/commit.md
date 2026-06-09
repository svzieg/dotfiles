# Commit Message

Generate a conventional commit message from the current diff. Uses the commit sub-agent.

## Instructions

1. Spawn the commit sub-agent using the Agent tool (agentType: "commit") with prompt:
"Analyze the current diff and generate a conventional commit message. Run `git diff --cached` for staged changes, or `git diff` for unstaged. Use commitizen convention (feat/fix/ci/refactor/docs/test/chore). Title under 50 chars. Body wrapped at 72. Include GitLab Changelog annotation. Check branch name for JIRA tickets (PAS- or INF-) and reference in footer."

$ARGUMENTS
