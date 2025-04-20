return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    require("notify").setup({
      render = "compact",
      stages = "fade",
      max_width = 80,
    })
    vim.notify = require("notify")
  end,
}
