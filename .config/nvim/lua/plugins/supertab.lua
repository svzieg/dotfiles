return {
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        ["<Tab>"] = {
          function()
            if require("minuet.virtualtext").action.is_visible() then
              require("minuet.virtualtext").action.accept_line()
              return true
            end
            return false
          end,
          "snippet_forward",
          LazyVim.cmp.map({ "ai_nes" }, "<Tab>"),
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        -- manual minuet invocation
        ["<A-y>"] = {
          function()
            require("minuet").blink_cmp_complete()
          end,
        },
      },
      sources = {
        default = { "lsp", "path", "buffer", "snippets", "minuet" },
        providers = {
          minuet = {
            name = "minuet",
            module = "minuet.blink",
            async = true,
            timeout_ms = 3000,
            score_offset = 50,
          },
        },
      },
      completion = {
        trigger = {
          prefetch_on_insert = false,
        },
      },
      appearance = {
        kind_icons = {
          Minuet = "󱚤",
        },
      },
    },
  },
}
