# Put pi package bin dirs on PATH.
#
# mcp.json takes the `command` field literally — pi does NOT expand $HOME there,
# and pi does not prepend package bin dirs when spawning MCP servers. So an
# mcp.json can either hardcode a machine-absolute path (breaks on every other
# machine) or name a bare binary that has to be resolvable on PATH.
#
# This script makes the bare form work, which is what keeps mcp.json portable
# across the machines that clone this repo.
export PATH="$PATH:$HOME/.pi/agent/npm/node_modules/.bin"
export PATH="$PATH:$HOME/.pi-work/agent/npm/node_modules/.bin"