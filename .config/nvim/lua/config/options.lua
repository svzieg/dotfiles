-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 500 -- Increased from 250ms to reduce LSP request frequency
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300

-- Unified clipboard: wl-copy on local Wayland, OSC52 everywhere else (SSH, tmux, nested)
local function osc52_copy(lines, _)
  local text = table.concat(lines, "\n")
  local encoded = vim.fn.system("base64", text):gsub("\n", "")
  local osc52 = string.format("\x1b]52;c;%s\x07", encoded)
  if os.getenv("TMUX") then
    -- tmux passthrough: escape ESC for DCS sequence
    io.stdout:write(string.format("\x1bPtmux;\x1b%s\x1b\\", osc52:gsub("\x1b", "\x1b\x1b")))
  else
    local tty = io.open("/dev/tty", "wb")
    if tty then
      tty:write(osc52)
      tty:close()
    else
      io.stdout:write(osc52)
    end
  end
end

local function osc52_paste()
  -- OSC52 is write-only; fallback to unnamed register
  return vim.fn.getreg('"')
end

if os.getenv("WAYLAND_DISPLAY") and not os.getenv("SSH_CONNECTION") then
  -- Local Wayland: use wl-copy with timeout to avoid hang
  vim.g.clipboard = {
    name = "wl-copy",
    copy = {
      ["+"] = { "bash", "-c", "timeout 0.5 wl-copy 2>/dev/null || true" },
      ["*"] = { "bash", "-c", "timeout 0.5 wl-copy 2>/dev/null || true" },
    },
    paste = {
      ["+"] = { "bash", "-c", "timeout 0.2 wl-paste --no-newline 2>/dev/null || true" },
      ["*"] = { "bash", "-c", "timeout 0.2 wl-paste --no-newline 2>/dev/null || true" },
    },
    cache_enabled = 0,
  }
else
  -- SSH / tmux / nested sessions: OSC52 terminal clipboard
  vim.g.clipboard = {
    name = "osc52",
    copy = {
      ["+"] = osc52_copy,
      ["*"] = osc52_copy,
    },
    paste = {
      ["+"] = osc52_paste,
      ["*"] = osc52_paste,
    },
    cache_enabled = 0,
  }
end
