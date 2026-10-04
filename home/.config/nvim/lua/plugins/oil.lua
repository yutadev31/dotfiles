return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-mini/mini.nvim",
  },
  lazy = false,
  opts = {
    win_options = {
      signcolumn = "auto:2",
    },
    view_options = {
      show_hidden = true,
    },
  },
  keys = {
    {
      "<leader>ee",
      "<cmd>Oil<cr>",
      desc = "Open parent directory",
    },
  },
}
