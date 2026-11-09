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

# ccburn is a PyInstaller onefile binary: every start unpacks ~45 MB into /tmp (RAM), and a
# SIGKILL leaves that /tmp/_MEI* dir behind. Usage limits are account-wide, so show a cached
# value (shared by all sessions) and refresh it at most once a minute, detached from this
# script so a killed statusline cannot kill ccburn mid-run.
CACHE="${XDG_RUNTIME_DIR:-/tmp}/ccburn-statusline.cache"
if command -v ccburn >/dev/null 2>&1; then
  BURN=$(cat "$CACHE" 2>/dev/null)
  if [ $(( $(date +%s) - $(stat -c %Y "$CACHE" 2>/dev/null || echo 0) )) -ge 60 ]; then
    setsid -f flock -n "$CACHE.lock" bash -c \
      'ccburn collect 2>/dev/null | ccburn --compact > "$1.tmp" 2>/dev/null && mv "$1.tmp" "$1"' \
      _ "$CACHE" <<<"$STDIN" >/dev/null 2>&1
  fi
fi
# Output the status line - ${DIR##*/} extracts just the folder name
echo "[$MODEL] - ${DIR##*/} | ${USED_K}k/${LIMIT_K}k (${PCT}%) context"
echo "$BURN"
