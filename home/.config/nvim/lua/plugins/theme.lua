return {
  "folke/tokyonight.nvim",
  opts = {
    style = "storm",
    transparent = true,
  },
  config = function(opts)
    require("tokyonight").setup(opts)
    vim.cmd("colorscheme tokyonight")
  end,
}
