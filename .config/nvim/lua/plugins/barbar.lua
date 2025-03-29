return {
  "romgrk/barbar.nvim",
  dependencies = {
    "lewis6991/gitsigns.nvim",
    "echasnovski/mini.nvim",
  },
  opts = {},
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  version = "^1.0.0",
}
