return {
  "windwp/nvim-ts-autotag",
  event = { "VimEnter" },
  priority = 1000,
  config = function()
    require("nvim-ts-autotag").setup({})
  end,
}
