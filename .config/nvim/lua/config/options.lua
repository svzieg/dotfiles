-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 500 -- Increased from 250ms to reduce LSP request frequency
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300

-- Use xsel for clipboard to avoid wl-paste hanging issues on Wayland
vim.g.clipboard = {
  name = "xsel",
  copy = {
    ["+"] = "xsel --clipboard --input",
    ["*"] = "xsel --clipboard --input",
  },
  paste = {
    ["+"] = "xsel --clipboard --output",
    ["*"] = "xsel --clipboard --output",
  },
  cache_enabled = 1,
}
