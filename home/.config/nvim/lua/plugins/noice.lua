return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.nvim",
  },
  config = function()
    require("noice").setup({
      cmdline = {
        enabled = true,
      },
      messages = {
        enabled = true,
      },
      popupmenu = {
        enabled = true,
      },
    })
  end,
}
