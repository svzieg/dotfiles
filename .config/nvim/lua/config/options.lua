-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 500 -- Increased from 250ms to reduce LSP request frequency
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300

-- Use wl-copy/wl-paste for clipboard on Wayland
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
