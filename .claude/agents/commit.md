---
name: commit
description: >
  Generate a conventional commit message from the current diff.
  Use for "write a commit message", "generate commit", "commit these changes".
model: inherit
color: cyan
tools: ["Read", "Grep", "Bash"]
---

# Commit Message Generator

Analyze the current diff and generate a conventional commit message.

1. Run `git diff --cached` for staged changes, or `git diff` for unstaged
2. Use commitizen convention:
   - **feat** for new features
   - **fix** for bug fixes
   - **ci** for pipeline/CI changes
   - **refactor**, **docs**, **test**, **chore** as appropriate
3. Keep the title under 50 characters
4. Wrap body at 72 characters
5. Include GitLab Changelog annotation: `Changelog: added` for features, `Changelog: fixed` for fixes
6. Check branch name for JIRA tickets (PAS- or INF-) and reference in footer

$ARGUMENTS
