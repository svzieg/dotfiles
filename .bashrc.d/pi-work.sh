# ~/.bashrc.d/pi-work.sh
# Work-context entry points. Personal pi stays on ~/.pi/agent; work pi uses
# ~/.pi-work/agent. Both are independent — no shared state, separate sessions.

# piw is now a script: ~/.local/bin/piw

# piwj — pi in a work project dir, work agent dir
piwj() {
	local dir="${1:-$PWD}"
	(cd "$dir" && piw)
}

# claudew — Claude Code with a separate work config dir
claudew() {
	CLAUDE_CONFIG_DIR="$HOME/.claude-work" command claude "$@"
}

# Regenerate the Langdock provider block in the work models.json
langdock-models() {
	LANGDOCK_API_KEY="${LANGDOCK_API_KEY:?export LANGDOCK_API_KEY first}" \
		node "$HOME/.pi-work/bin/langdock-provider.mjs" --write "$HOME/.pi-work/agent/models.json"
}