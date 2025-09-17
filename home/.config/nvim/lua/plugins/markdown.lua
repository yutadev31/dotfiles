return {
  {
    "ixru/nvim-markdown",
    ft = { "markdown" },
  },
  {

    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
      completions = {
        lsp = { enabled = true },
      },
      heading = {
        position = "inline",
        border = true,
        icons = { "󰼏 ", "󰼐 ", "󰼑 ", "󰼒 ", "󰼓 ", "󰼔 " },
      },
    },
  },
}
