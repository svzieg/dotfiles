return {
  -- AI sidekick: extends LazyVim sidekick extra with NES disabled + tmux + Claude shortcut
  {
    "folke/sidekick.nvim",
    opts = {
      -- Disable NES (Next Edit Suggestions) from Copilot LSP
      nes = {
        enabled = false,
      },
      cli = {
        mux = {
          backend = vim.env.ZELLIJ and "zellij" or "tmux",
          enabled = true,
        },
      },
    },
    keys = {
      -- Claude shortcut not in the LazyVim extra defaults
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Sidekick Toggle Claude",
      },
    },
  },

  -- Local LLM completion via LM Studio (OpenAI-FIM-compatible endpoint)
  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup({
        duet = {
          provider = "openai_compatible",
        },
        provider = "openai_fim_compatible",
        n_completions = 1,
        context_window = 512,
        provider_options = {
          openai_fim_compatible = {
            api_key = "TERM",
            name = "LMStudio",
            end_point = "http://localhost:1234/v1/completions",
            stream = true,
            model = "qwen/qwen2.5-coder-14b",
            optional = {
              max_tokens = 256,
              top_p = 0.9,
            },
          },

          openai_compatible = {
            api_key = "LMSTUDIO_API_KEY",
            name = "LMStudio",
            end_point = "http://localhost:1234/v1/chat/completions",
            stream = true,
            model = "qwen/qwen3.5-9b",
            optional = {
              reasoning_effort = "none",
              max_tokens = 256,
              top_p = 0.9,
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = { "*" },
          keymap = {
            accept = "<A-A>",
            accept_line = "<A-a>",
            accept_n_lines = "<A-z>",
            prev = "<A-[>",
            next = "<A-]>",
            dismiss = "<A-e>",
          },
        },
      })
    end,
  },
}
