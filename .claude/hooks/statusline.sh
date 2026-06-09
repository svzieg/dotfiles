#!/usr/bin/env bash
# statusline: context-mode stats + ccburn + current model
PARTS=()
STDIN=$(cat)

# Extract fields using jq
MODEL=$(echo "$STDIN" | jq -r '.model.display_name')
DIR=$(echo "$STDIN" | jq -r '.workspace.current_dir')
# The "// 0" provides a fallback if the field is null
PCT=$(echo "$STDIN" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

if [ -f "$HOME/.claude/plugins/marketplaces/context-mode/bin/statusline.mjs" ]; then
  CTX_OUT=$(printf '%s' "$STDIN" | "$HOME/.claude/plugins/marketplaces/context-mode/bin/statusline.mjs" 2>/dev/null)
  [ -n "$CTX_OUT" ] && PARTS+=("$CTX_OUT")
fi

if command -v ccburn >/dev/null 2>&1; then
  BURN=$(echo "$STDIN" | ccburn collect 2>/dev/null | ccburn --compact)
fi
# Output the status line - ${DIR##*/} extracts just the folder name
echo "$CTX_OUT - [$MODEL] - ${DIR##*/} | ${PCT}% context | $BURN"
