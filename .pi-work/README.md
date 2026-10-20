# Work-context pi

Separate pi + Claude Code context for the company machine/network.
Independent from the personal `~/.pi/agent` — no shared config, no shared sessions.

## Layout

```
~/.pi-work/
  agent/            <- PI_CODING_AGENT_DIR
    settings.json     model defaults, packages, enabledModels
    mcp.json          MCP servers
    AGENTS.md         work instructions + routing rules
    models.json       (generated) Langdock provider — see below
  bin/
    langdock-provider.mjs   queries the workspace, emits the provider block
  sessions/         <- PI_CODING_AGENT_SESSION_DIR
```

## Calling it

Sourced from `~/.bashrc.d/pi-work.sh`:

| Command | Effect |
|---|---|
| `piw` | pi with the work agent dir (`piw`, `piw --continue`, `piw -p "..."`) |
| `piwj <dir>` | same, but cwd set to a work project first |
| `claudew` | Claude Code with `CLAUDE_CONFIG_DIR=~/.claude-work` |
| `langdock-models` | regenerate `agent/models.json` from the live workspace |

Reload your shell after this change: `source ~/.bashrc.d/pi-work.sh`.

## Why mcp.json says `"command": "context-mode"` and not a path

pi takes the `command` field **literally**: it does not expand `$HOME` there and it does not
prepend package bin dirs when spawning MCP servers. So an MCP entry can only be either a
machine-absolute path (breaks on every other machine that clones this repo) or a bare binary
name that must be resolvable on `PATH`.

`~/.bashrc.d/pi-paths.sh` puts both package bin dirs on `PATH`, which is what makes the bare
form work on any machine. Keep it. If you ever hardcode an absolute path into `mcp.json` again,
this repo stops being portable.

## Skills do not carry over

A separate agent dir means a separate resource tree. `~/.pi/agent/skills/` (the
matt-pocock flow: `wayfinder`, `to-spec`, `to-tickets`, `implement`, `code-review`,
`tdd`, `research`, `obsidian-vault`, `minimax-multimodal-toolkit`, …) is **not**
visible from `~/.pi-work/agent`. Symlink the ones you want:

```bash
mkdir -p ~/.pi-work/agent/skills
ln -s ~/.agents/skills/tdd ~/.pi-work/agent/skills/tdd
```

Note `minimax-multimodal-toolkit` is a *skill*, not a package — it must be symlinked,
not added to `packages`.

## Langdock

Langdock is an OpenAI-compatible enterprise gateway — `https://api.langdock.com/openai/{eu|us}/v1`,
Bearer auth, models from `GET /openai/{region}/v1/models`. There is **no MCP server**, so
it integrates as a `models.json` endpoint, not as a plugin or extension.

Setup:

```bash
export LANGDOCK_API_KEY=...        # keep it in ~/.bashrc.d/pi.secrets, never in this repo
langdock-models                    # writes ~/.pi-work/agent/models.json
piw /model                         # langdock/* entries appear once credentials resolve
```

Region defaults to `eu`; set `LANGDOCK_REGION=us` for US workspaces. Dedicated
deployments: set `LANGDOCK_DEPLOY=https://<deployment>/api/public`.

`contextWindow` and `maxTokens` in the generator are conservative placeholders
(128000 / 32768) because they vary per proxied model. Correct them in
`agent/models.json` once you know the real limits.

Once Langdock is the intended default, change `defaultProvider` in
`agent/settings.json` from `openai-codex` to `langdock`.

## Transferring to another PC

`.pi-work/` is tracked in the dotfiles repo (`~/.cfg` bare, remote `github.com/svzieg/dotfiles.git`).
`agent/auth.json`, `agent/models-store.json`, and `agent/trust.json` stay untracked on every
machine — each PC authenticates its own credentials.

## Not yet decided

- Company git remote and branch conventions.
- Whether code may leave the company network.
- Session/log retention on the work machine.
- Whether `claudew` should also get its own skills/agents, or share with personal.