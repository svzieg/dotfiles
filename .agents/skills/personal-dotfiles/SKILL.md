---
name: personal-dotfiles
description: How personal config on this machine is versioned — the ~/.cfg bare git repo with work-tree $HOME (GitHub svzieg/dotfiles) — and where hand-written Pi packages live. Use when asked to commit dotfiles/config, to add or update a personal Pi extension, to share a Pi package with a colleague, or when the user says ~/.cfg, "my bare repo", dotfiles, or "commit that".
---

# Personal dotfiles and Pi packages

## The `~/.cfg` bare repo

| Property | Value |
|---|---|
| Git dir | `~/.cfg` (bare) |
| Work tree | `$HOME` — so the repo root **is** `$HOME` |
| Remote | `git@github.com:svzieg/dotfiles.git`, branch `main` |
| Untracked files | hidden (`status.showUntrackedFiles = no`) |
| Effective ignores | `$HOME/.gitignore`, `.pi/.gitignore`, `.pi-work/.gitignore`, `.claude/.gitignore` |

`~/.cfg/.gitignore` is **inert** — it only documents which ignore files actually apply. Do not add rules there.

### Commands

```bash
cd "$HOME" && G="git --git-dir=$HOME/.cfg --work-tree=$HOME"
$G status --short
$G add <explicit paths>          # e.g. coding/pi-extensions/pi-idle-trim
$G commit -m "pi: <what changed>"
$G push                          # origin main
```

### Rules that matter

- **Always `cd "$HOME"` first.** Pathspecs resolve against the cwd; from any other directory they silently match nothing (looks like "no changes").
- **Never `git add -A` or `git add .`.** The work tree is `$HOME`, so sessions, caches, `node_modules` and logs live there.
- Never commit: `.pi*/sessions/**`, `.pi*/npm/**`, `auth.json`, `mcp-cache.json`, logs, counters.
- Commit messages in this repo use a `pi: `, `claude: `, `shell: ` prefix.

Tracked today: ~105 files (shell rc, `.agents/.skill-lock.json`, `.pi*/settings.json`, `.pi/agent/extensions/`, `.claude/`, …). Untracked by design: `.agents/skills/**` (installed from GitHub sources via the skills tool), `coding/**` except what is added deliberately.

## Personal Pi packages

- Code lives at `~/coding/pi-extensions/<package>/` — one directory per package, each with a `package.json` that has `"pi": { "extensions": ["./index.ts"] }`.
- Installed into **both** profiles by absolute path, no copies:
  ```bash
  pi  install /home/u500132/coding/pi-extensions/<package>
  piw install /home/u500132/coding/pi-extensions/<package>
  ```
  Both write into tracked settings (`~/.pi/agent/settings.json`, `~/.pi-work/agent/settings.json`), so commit those two files with the package.
- Edits are live after `/reload` — no reinstall, no version bump.
- `piw` is a wrapper: `PI_CODING_AGENT_DIR=~/.pi-work/agent`, `PI_CODING_AGENT_SESSION_DIR=~/.pi-work/sessions` (`~/.local/bin/piw`). Work sessions therefore live in `~/.pi-work/sessions`, not under `agent/`.

### Sharing a package with someone else

The directory is already a Pi package, so nothing needs rewriting:

```bash
cd ~/coding/pi-extensions && git tag <package>/v0.1.0 && git push --tags
# colleague:
pi install git:gitlab.scheer-group.com/<group>/<repo>@<package>/v0.1.0
```

Publish to an npm registry only when version resolution or lockfile pinning is actually needed.

## Packages in use

| Package | Purpose |
|---|---|
| `pi-idle-trim` | Mechanical (no model call) context trim on the first message after the prompt cache expired; deterministic digest instead of an AI summary. |
