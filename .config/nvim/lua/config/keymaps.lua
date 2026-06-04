-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- claudecode.nvim keymaps defined in lua/plugins/copilot.lua (ac/af/am/av/aA/ady/adn)

-- Send a slash command to Claude Code
-- Pattern: ensure CC is open, focus it, send "/<cmd> <args>" + enter.
local function run_slash(name)
  return function()
    vim.cmd("ClaudeCode")
    vim.defer_fn(function()
      local ok, snacks = pcall(require, "snacks.terminal")
      if not ok then
        vim.notify("snacks.terminal not available", vim.log.levels.WARN)
        return
      end
      local term = snacks.get()
      if not term then
        vim.cmd("ClaudeCodeFocus")
        vim.defer_fn(function()
          term = snacks.get()
          if term then
            term:send("/" .. name .. "\r")
          end
        end, 80)
        return
      end
      term:send("/" .. name .. "\r")
    end, 60)
  end
end

-- Slash command shortcuts (custom commands live in ~/.claude/commands/)
vim.keymap.set("n", "<leader>ar", run_slash("review"), { desc = "Claude: /review (code review)" })
vim.keymap.set("n", "<leader>aC", run_slash("commit"), { desc = "Claude: /commit (commit msg)" })
vim.keymap.set("n", "<leader>ad", run_slash("docs"), { desc = "Claude: /docs (generate docs)" })
vim.keymap.set("n", "<leader>ax", run_slash("cleanup"), { desc = "Claude: /cleanup (deslop+verbosity)" })
vim.keymap.set("n", "<leader>ao", run_slash("oracle"), { desc = "Claude: /oracle (adversarial review)" })
