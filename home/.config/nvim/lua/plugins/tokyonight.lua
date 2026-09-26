return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function(opts)
    require("tokyonight").setup({
      style = "storm",
      transparent = true,
    })

    vim.cmd("colorscheme tokyonight")
  end,
}
