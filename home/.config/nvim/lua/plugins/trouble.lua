return {
  "folke/trouble.nvim",
  opts = {},
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo" },
  },
}
