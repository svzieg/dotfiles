-- sidekick.nvim mux backend for herdr (https://herdr.dev).
--
-- Mirrors sidekick.cli.session.tmux's "split" mode: each CLI tool gets a
-- pane split next to the calling pane (not a separate tab -- agents show
-- in herdr's sidebar by pane regardless of tab, and a same-tab split keeps
-- normal herdr pane-nav working), started via `herdr agent start`. The
-- pane is already visible in herdr's own layout, so :start() never returns
-- a Cmd (nothing for sidekick to embed in a floating terminal) --
-- send/submit/toggle/picker all go through herdr's pane API instead, the
-- same way tmux's external-split mode works.
local Config = require("sidekick.config")
local Util = require("sidekick.util")

---@class sidekick.cli.muxer.Herdr: sidekick.cli.Session
---@field herdr_pane_id string
---@field herdr_agent_name string
---@field herdr_tab_id string
local M = {}
M.__index = M
M.priority = 50

local function direction()
  return Config.cli.mux.split.vertical and "right" or "down"
end

-- sidekick tool name -> herdr `agent start --kind`. Only tools herdr can
-- actually run as a recognized agent; add more as they're needed.
local KIND = {
  claude = "claude",
  codex = "codex",
  gemini = "gemini",
  cursor = "cursor",
  copilot = "copilot",
  opencode = "opencode",
  grok = "grok",
  pi = "pi",
}
local TOOL_FOR_KIND = {}
for tool, kind in pairs(KIND) do
  TOOL_FOR_KIND[kind] = tool
end

-- A freshly created tab's pane briefly reports agent_pane_busy: herdr's
-- shell-prompt detection needs a moment (observed ~1-3s) to settle before
-- it considers the pane an available shell. Retry instead of guessing a
-- fixed delay.
---@return boolean ok, string? err
local function start_agent(name, kind, pane_id)
  for attempt = 1, 10 do
    local res = vim.system({ "herdr", "agent", "start", name, "--kind", kind, "--pane", pane_id }, { text = true })
      :wait()
    if res.code == 0 then
      return true
    end
    if not (res.stderr or ""):find("agent_pane_busy", 1, true) then
      return false, res.stderr
    end
    vim.wait(300 + attempt * 100)
  end
  return false, "timed out waiting for an available shell pane"
end

---@param cmd string[]
---@return table? data, string? stdout
local function json(cmd)
  local _, out = Util.exec(cmd)
  if not out then
    return nil
  end
  local ok, data = pcall(vim.json.decode, out)
  return ok and data or nil, out
end

---@return {pane_id: string, tab_id: string}?
local function current_pane()
  local data = json({ "herdr", "pane", "current", "--current" })
  return data and data.result and data.result.pane
end

function M:is_running()
  if not self.herdr_pane_id then
    return false
  end
  return json({ "herdr", "agent", "get", self.herdr_pane_id }) ~= nil
end

-- One split+start attempt. Returns the pane on success; on failure closes
-- the (broken) pane it opened and returns nil, err.
---@return {pane_id: string, tab_id: string}? pane, string? err
local function try_start(cwd, name, kind)
  local data = json({
    "herdr",
    "pane",
    "split",
    "--current",
    "--direction",
    direction(),
    "--ratio",
    tostring(Config.cli.mux.split.size),
    "--cwd",
    cwd,
    "--focus",
  })
  local pane = data and data.result and data.result.pane
  if not pane then
    return nil, "herdr pane split failed"
  end

  -- Note: herdr's --kind resolves its own canonical executable via its
  -- own integration (see `herdr integration status`), so self.tool.cmd
  -- (a tmux/zellij-only login-shell/PATH workaround) is not used here.
  local ok, err = start_agent(name, kind, pane.pane_id)
  if not ok then
    Util.exec({ "herdr", "pane", "close", pane.pane_id }, { notify = false })
    return nil, err
  end
  return pane
end

-- Occasionally the very first `agent start` against a fresh pane times out
-- waiting for interactive readiness and the launched process dies (herdr's
-- own cold-start detection, not something we control) -- retrying from
-- scratch with a new pane reliably works. Automate that instead of making
-- the user notice a bare terminal and retry by hand.
---@return sidekick.cli.terminal.Cmd?
function M:start()
  local kind = KIND[self.tool.name]
  if not kind then
    Util.warn(("herdr has no agent kind for %q"):format(self.tool.name))
    return
  end

  local name = ("sk_%s_%s"):format(self.tool.name, vim.fn.sha256(self.cwd):sub(1, 8))
  local pane, err
  for attempt = 1, 2 do
    pane, err = try_start(self.cwd, name, kind)
    if pane then
      break
    end
  end
  if not pane then
    Util.error("herdr agent start failed: " .. (err or ""))
    return
  end

  Util.exec({ "herdr", "pane", "rename", pane.pane_id, kind:sub(1, 1):upper() .. kind:sub(2) }, { notify = false })

  self.herdr_pane_id = pane.pane_id
  self.herdr_tab_id = pane.tab_id
  self.herdr_agent_name = name
  self.id = "herdr " .. pane.pane_id
  self.started = true
  Util.info(("Started **%s** in a new herdr split"):format(self.tool.name))
end

---Bring an already-running agent's pane to the caller: if it's already in
---the current tab, just focus it; otherwise move it in as a local split
---instead of jumping the whole herdr view away to wherever it lives.
function M:attach()
  local here = current_pane()
  if not here then
    Util.exec({ "herdr", "agent", "focus", self.herdr_pane_id }, { notify = false })
    return
  end
  if self.herdr_tab_id == here.tab_id then
    Util.exec({ "herdr", "agent", "focus", self.herdr_pane_id }, { notify = false })
    return
  end
  Util.exec({
    "herdr",
    "pane",
    "move",
    self.herdr_pane_id,
    "--tab",
    here.tab_id,
    "--target-pane",
    here.pane_id,
    "--split",
    direction(),
    "--focus",
  }, { notify = false })
  self.herdr_tab_id = here.tab_id
end

---Send literal text to the pane (no Enter -- see :submit())
---@param text string
function M:send(text)
  Util.exec({ "herdr", "pane", "send-text", self.herdr_pane_id, text })
end

function M:submit()
  Util.exec({ "herdr", "pane", "send-keys", self.herdr_pane_id, "enter" })
end

function M:dump()
  local _, out = Util.exec({ "herdr", "pane", "read", self.herdr_pane_id, "--lines", tostring(Config.cli.mux.dump) })
  return out
end

function M.sessions()
  local data = json({ "herdr", "agent", "list" })
  local ret = {} ---@type sidekick.cli.session.State[]
  for _, a in ipairs(data and data.result and data.result.agents or {}) do
    local tool = TOOL_FOR_KIND[a.agent]
    if tool and a.cwd then
      ret[#ret + 1] = {
        id = "herdr " .. a.pane_id,
        cwd = a.cwd,
        tool = tool,
        herdr_pane_id = a.pane_id,
        herdr_tab_id = a.tab_id,
        herdr_agent_name = a.name,
        pids = {},
      }
    end
  end
  return ret
end

return M
