return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
    "ibhagwan/fzf-lua",
    "echasnovski/mini.pick",
  },
  config = function()
    local h = require("yutadev31.utils.helper")
    h.nmap("<leader>gg", "<CMD>Neogit<CR>")
  end,
}
