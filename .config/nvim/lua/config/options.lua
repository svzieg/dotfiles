-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 500 -- Increased from 250ms to reduce LSP request frequency
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300

-- LazyVim disables clipboard over SSH by default to avoid lag.
-- We force unnamedplus everywhere; the provider below handles it.
vim.opt.clipboard = "unnamedplus"

if os.getenv("WAYLAND_DISPLAY") and not os.getenv("SSH_CONNECTION") then
  -- Local Wayland only: wl-copy with timeout to prevent hang
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
elseif not os.getenv("TMUX") then
  -- SSH without tmux: force built-in OSC52
  vim.g.clipboard = "osc52"
end
-- When TMUX is set (SSH or not), leave g:clipboard unset so Neovim
-- auto-detects the tmux provider (tmux load-buffer -w -).
-- With tmux set-clipboard on, this forwards to the system clipboard.
