-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- AI keymaps provided by LazyVim sidekick extra + plugins/copilot.lua

-- Sidekick template variables:
--   {file}        current file path
--   {this}        context at cursor (function/block)
--   {selection}   visual selection
--   {line}        current line
--   {position}    cursor position
--   {diagnostics} current buffer diagnostics

--- Send a slash command to sidekick Claude CLI with file context
--- @param name string slash command name (without /)
--- @param ctx string? template variable for context (default: "{file}")
local function run_slash(name, ctx)
  ctx = ctx or "{file}"
  return function()
    require("sidekick.cli").send({ name = "claude", msg = "/" .. name .. " " .. ctx, focus = true })
  end
end

-- Slash command shortcuts (custom commands live in ~/.claude/commands/)

-- File-scoped (normal mode)
vim.keymap.set("n", "<leader>ar", run_slash("review"), { desc = "Claude: /review file" })
vim.keymap.set("n", "<leader>ao", run_slash("oracle"), { desc = "Claude: /oracle file" })
vim.keymap.set("n", "<leader>ad", run_slash("docs"), { desc = "Claude: /docs file" })
vim.keymap.set("n", "<leader>aC", run_slash("commit"), { desc = "Claude: /commit" })
vim.keymap.set("n", "<leader>ax", run_slash("cleanup"), { desc = "Claude: /cleanup file" })

-- Selection-scoped (visual mode) — references the selected code region
vim.keymap.set("v", "<leader>ar", run_slash("review", "{selection}"), { desc = "Claude: /review selection" })
vim.keymap.set("v", "<leader>ao", run_slash("oracle", "{selection}"), { desc = "Claude: /oracle selection" })
vim.keymap.set("v", "<leader>ad", run_slash("docs", "{selection}"), { desc = "Claude: /docs selection" })
vim.keymap.set("v", "<leader>ax", run_slash("cleanup", "{selection}"), { desc = "Claude: /cleanup selection" })
