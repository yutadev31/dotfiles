return {
  "rcarriga/nvim-notify",
  event = { "VimEnter" },
  priority = 1000,
  config = function()
    require("notify").setup({
      render = "compact",
      stages = "fade",
      max_width = 80,
    })
    vim.notify = require("notify")
  end,
}
