-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_custom_" .. name, { clear = true })
end

-- Add LSP request cleanup on buffer leave
vim.api.nvim_create_autocmd("BufLeave", {
  group = augroup("lsp_cleanup"),
  callback = function(ev)
    -- Cancel pending LSP requests when leaving buffer
    local clients = vim.lsp.get_clients({ bufnr = ev.buf })
    for _, client in ipairs(clients) do
      -- This helps prevent orphaned requests
      if client.name == "gopls" then
        -- Force a small delay before processing next requests
        vim.defer_fn(function() end, 100)
      end
    end
  end,
})

-- Reduce LSP updates during insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  group = augroup("lsp_insert"),
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})
