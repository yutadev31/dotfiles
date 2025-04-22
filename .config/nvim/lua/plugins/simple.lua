return {
  "yutadev31/simple.nvim",
  config = function()
    require("simple.statusline").setup()
    require("simple.tabline").setup()
  end,
}
