return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "jay-babu/mason-null-ls.nvim",
      "nvim-lua/plenary.nvim",
    },
    event = "BufReadPre",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {},
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        automatic_setup = true,
        handlers = {},
      })
    end,
  },
}
