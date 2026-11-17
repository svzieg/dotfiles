#!/usr/bin/env bash
# statusline: ccburn + current model
STDIN=$(cat)

# Extract fields using jq
MODEL=$(echo "$STDIN" | jq -r '.model.display_name')
DIR=$(echo "$STDIN" | jq -r '.workspace.current_dir')
# The "// 0" provides a fallback if the field is null
PCT=$(echo "$STDIN" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
LIMIT=$(echo "$STDIN" | jq -r '.context_window.context_window_size // 0')
LIMIT_K=$((LIMIT / 1000))
USED_K=$(echo "$STDIN" | jq -r '((.context_window.used_percentage // 0) * (.context_window.context_window_size // 0) / 100 / 1000 | floor)')

# Share the profile-scoped cache/lock with Pi. Reads never start ccburn; the detached
# refresh rechecks its timestamp under the lock and collects native rate_limits first.
BURN=""
HELPER="$HOME/.claude/hooks/ccburn-cache.py"
if command -v ccburn >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1; then
  BURN=$(python3 "$HELPER" --cached 2>/dev/null)
  setsid -f python3 "$HELPER" --refresh <<<"$STDIN" >/dev/null 2>&1
fi
# Output the status line - ${DIR##*/} extracts just the folder name
echo "[$MODEL] - ${DIR##*/} | ${USED_K}k/${LIMIT_K}k (${PCT}%) context"
echo "$BURN"
