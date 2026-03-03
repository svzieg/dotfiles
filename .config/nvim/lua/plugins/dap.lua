return {
  "mfussenegger/nvim-dap",
  enabled = not vim.g.vscode,
  dependencies = {
    "leoluz/nvim-dap-go",
  },
  config = function()
    -- Load project-specific DAP config
    local project_dap = vim.fn.getcwd() .. "/.nvim/dap.lua"
    if vim.fn.filereadable(project_dap) == 1 then
      dofile(project_dap)
    end

    require("dap-go").setup()
  end,
}
