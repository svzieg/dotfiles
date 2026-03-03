return {
  {
    "neovim/nvim-lspconfig",
    enabled = not vim.g.vscode,
    dependencies = {
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        opts = {},
      },
    },
    opts = {
      -- Increase debounce to reduce rapid LSP requests
      diagnostics = {
        update_in_insert = false, -- Don't update diagnostics while typing
        virtual_text = {
          spacing = 4,
          prefix = "●",
        },
      },
      -- Add debounce for document changes
      document_highlight = {
        enabled = true,
      },
      -- Reduce codelens refresh rate
      codelens = {
        enabled = true,
      },
      -- Configure inlay hints with debounce
      inlay_hints = {
        enabled = true,
      },
      -- Increase capabilities timeout
      servers = {
        ["*"] = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = false, -- Reduce file watching overhead
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = false, -- Can be expensive
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = false, -- Disable to prevent request buildup
              -- Add memory limits
              memoryMode = "Normal", -- Can be "DegradeClosed" for large projects
            },
          },
          -- Add flags to control request timing
          flags = {
            debounce_text_changes = 500, -- Increased from default 150ms
            allow_incremental_sync = true,
          },
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
          flags = {
            debounce_text_changes = 300,
          },
        },
      },
    },
  },
}
