return {
  "saghen/blink.cmp",
  dependencies = {
    'saghen/blink.lib',
    "rafamadriz/friendly-snippets",
  },
  build = function()
    require('blink.cmp').build():pwait()
  end,
  event = "InsertEnter",
  opts = {
    keymap = {
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
      documentation = { auto_show = true },
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
  },
}
