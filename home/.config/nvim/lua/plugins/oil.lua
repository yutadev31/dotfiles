return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-mini/mini.nvim",
  },
  lazy = false,
  opts = {
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
