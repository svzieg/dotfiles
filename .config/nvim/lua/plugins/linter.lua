return {
  {
    "mfussenegger/nvim-lint",
    enabled = not vim.g.vscode,
    optional = true,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = { ensure_installed = { "golangci-lint" } },
      },
    },
    opts = function(_, opts)
      -- Ensure linters_by_ft table exists
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.go = { "golangcilint" }

      -- Override golangci-lint configuration
      local lint = require("lint")
      lint.linters.golangcilint = {
        cmd = "golangci-lint",
        name = "golangcilint",
        stdin = false,
        args = {
          "run",
          "--out-format=json",
          "--issues-exit-code=0",
          "--fast", -- Skip some checks for speed
          "--timeout=10s", -- Increased from 5s to prevent timeout races
          "--max-issues-per-linter=50", -- Limit output
        },
        ignore_exitcode = true,
        parser = require("lint.linters.golangcilint").parser,
      }

      return opts
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },
}
