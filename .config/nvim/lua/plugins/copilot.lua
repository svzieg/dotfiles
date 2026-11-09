return {
  -- AI sidekick: extends LazyVim sidekick extra with NES disabled + tmux/herdr + Claude shortcut
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
        -- claude is exec'd directly by the mux backend (no shell in between),
        -- so ~/.zshrc never runs for it. Wrap in a login+interactive zsh that
        -- sources rc, then `exec claude` so the process stays named "claude"
        -- (sidekick's is_proc detection matches on the name).
        tools = {
          claude = { cmd = { "zsh", "-lic", "exec claude" } },
        },
      },
    },
    -- Under herdr, swap in the herdr mux backend (lua/util/sidekick_herdr.lua)
    -- instead of tmux/zellij, so `<leader>ac` and friends open the agent in a
    -- herdr tab (visible in herdr's own agent sidebar). Done after setup() and
    -- deferred one more tick so it lands after sidekick's own opts validation,
    -- which only accepts "tmux"|"zellij" for cli.mux.backend.
    config = function(_, opts)
      require("sidekick").setup(opts)
      if vim.env.HERDR_ENV == "1" then
        vim.schedule(function()
          require("sidekick.cli.session").register("herdr", require("util.sidekick_herdr"))
          require("sidekick.config").cli.mux.backend = "herdr"
          require("sidekick.config").cli.mux.create = "window"
        end)
      end
    end,
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
          provider = vim.env.NVIM_DUET_PROVIDER or "openai_compatible",
        },
        provider = vim.env.NVIM_FIM_PROVIDER or "openai_compatible",
        n_completions = 1,
        context_window = 512,
        provider_options = {
          openai_fim_compatible = {
            api_key = vim.env.NVIM_FIM_API_KEY or "TERM",
            name = vim.env.NVIM_FIM_NAME or "LMStudio",
            end_point = vim.env.NVIM_FIM_ENDPOINT or "http://localhost:1234/v1/completions",
            stream = true,
            model = vim.env.NVIM_FIM_MODEL or "qwen/qwen2.5-coder-14b",
            optional = {
              reasoning_effort = "none",
              max_tokens = 256,
              top_p = 0.9,
            },
            template = {
              prompt = function(context_before_cursor, context_after_cursor)
                return "<|fim_prefix|>"
                  .. context_before_cursor
                  .. "<|fim_suffix|>"
                  .. context_after_cursor
                  .. "<|fim_middle|>"
              end,
              suffix = false,
            },
          },

          openai_compatible = {
            api_key = vim.env.NVIM_CHAT_API_KEY or "LMSTUDIO_API_KEY",
            name = vim.env.NVIM_CHAT_NAME or "LMStudio",
            end_point = vim.env.NVIM_CHAT_ENDPOINT or "http://localhost:1234/v1/chat/completions",
            stream = true,
            model = vim.env.NVIM_CHAT_MODEL or "qwen/qwen3.5-9b",
            optional = {
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
