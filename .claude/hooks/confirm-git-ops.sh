#!/usr/bin/env bash
# PreToolUse hook: block git commit/merge, ask user to confirm.
# stdin = JSON with tool_input.command

set -euo pipefail

CMD=$(jq -r '.tool_input.command // ""')

# Match git commit or git merge anywhere in the command
if echo "$CMD" | grep -qE '\bgit\s+(commit|merge)\b'; then
  OP=$(echo "$CMD" | grep -oE '\bgit\s+(commit|merge)\b' | head -1)
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "Confirm: $OP — $CMD"
  }
}
EOF
  exit 0
fi

exit 0
