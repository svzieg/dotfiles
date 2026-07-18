#!/usr/bin/env bash
# PreToolUse hook: block cd/ln/pushd that target outside the project directory.
# stdin = JSON with tool_input.command

set -euo pipefail

CMD=$(jq -r '.tool_input.command // ""')

# Resolve project root: CLAUDE_PROJECT_DIR > git rev-parse > pwd
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-}"
if [ -z "$PROJECT_DIR" ]; then
  PROJECT_DIR=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
fi
PROJECT_DIR=$(cd "$PROJECT_DIR" && pwd -P)

# No cd/ln/pushd found → allow
if ! echo "$CMD" | grep -qE '\b(cd|pushd|ln)\b'; then
  exit 0
fi

# Extract targets and check each one
VIOLATIONS=""
while IFS= read -r target; do
  [ -z "$target" ] && continue
  # "cd -" toggles back — can't resolve at hook time
  if [ "$target" = "-" ]; then
    VIOLATIONS="${VIOLATIONS}cd - (previous dir, cannot verify); "
    continue
  fi
  # Resolve to absolute path relative to project dir
  if [[ "$target" == /* ]]; then
    ABS="$target"
  else
    ABS="$PROJECT_DIR/$target"
  fi
  # canonicalize
  RESOLVED=$(cd "$ABS" 2>/dev/null && pwd -P 2>/dev/null || echo "$ABS")
  # Check if resolved path is outside project
  if [[ "$RESOLVED" != "$PROJECT_DIR"* ]]; then
    VIOLATIONS="${VIOLATIONS}${target} → ${RESOLVED}; "
  fi
done < <(echo "$CMD" | grep -oP '(?<=\b(cd|pushd|ln\s+-s\s+\S+\s+)\s)\S+' 2>/dev/null || true)

# Fallback: simpler extraction if perl regex not available
if [ -z "$VIOLATIONS" ]; then
  # Try extracting cd targets with basic grep/sed
  while IFS= read -r target; do
    [ -z "$target" ] && continue
    [ "$target" = "-" ] && { VIOLATIONS="${VIOLATIONS}cd - (previous dir); "; continue; }
    [[ "$target" == -* ]] && continue  # skip flags
    if [[ "$target" == /* ]]; then
      ABS="$target"
    else
      ABS="$PROJECT_DIR/$target"
    fi
    RESOLVED=$(cd "$ABS" 2>/dev/null && pwd -P 2>/dev/null || echo "$ABS")
    if [[ "$RESOLVED" != "$PROJECT_DIR"* ]]; then
      VIOLATIONS="${VIOLATIONS}${target} → ${RESOLVED}; "
    fi
  done < <(echo "$CMD" | sed -n 's/.*\bcd[[:space:]]\+\([^[:space:]]*\).*/\1/p' 2>/dev/null || true)
fi

if [ -n "$VIOLATIONS" ]; then
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "Outside project dir ($PROJECT_DIR): ${VIOLATIONS}"
  }
}
EOF
  exit 0
fi

exit 0
