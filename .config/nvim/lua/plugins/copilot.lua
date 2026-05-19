return {
  { "pablopunk/pi.nvim", opts = { thinking = "minimal" } },
  {
    "carderne/pi-nvim",
    config = function()
      require("pi-nvim").setup({
        debug = false, -- Enable debugging
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp",
      init = function()
        vim.g.copilot_nes_debounce = 500
      end,
    },
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        nes = {
          enable = true,
        },
      })
    end,
  },
  {
    "giuxtaposition/blink-cmp-copilot",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "hrsh7th/nvim-cmp",
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      model = "claude-sonnet-4.6",
      prompts = {
        Commit = {
          prompt = "Write commit message for the change with commitizen convention. Use 'feat' for new feature, 'fix' for bug fixes, 'ci' for changes on pipeline changes. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block. Include a Gitlab Changelog Annotation, use 'Changelog: added' for features, 'Changelog: fixed' for fixes. Check the Branch name and if there is a JIRA Ticket in it (startin with PAS- or INF-) reference them in the Commit Footer.",
        },
        KubebuilderAPI = {
          prompt = "Generate kubebuilder documentation for the following kubebuilder api code. als add meaninfull kubernetes and kubebuilder annotations. If helpful also add some examples here. The examples should be in yaml format. Ensure that the documentation is clear and concise. Assume the comments are processed by asciidoctor to create the documentation. As gofmt formats the code, ensure that the generated code is gofmted too. and use tabs instead of spaces in code blocks",
        },
      },
      debug = false, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
