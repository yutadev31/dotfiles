return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local h = require("yutadev31.utils.helper")
    local builtin = require("telescope.builtin")

    h.nmap("<leader>ff", builtin.find_files)
    h.nmap("<leader>fg", builtin.live_grep)
    h.nmap("<leader>fb", builtin.buffers)
    h.nmap("<leader>fh", builtin.help_tags)

    h.nmap("<leader>fd", builtin.diagnostics)
    h.nmap("<leader>fr", builtin.lsp_references)
    h.nmap("<leader>fs", builtin.lsp_document_symbols)
    h.nmap("<leader>fw", builtin.lsp_workspace_symbols)

    h.nmap("<leader>gc", builtin.git_commits)
    h.nmap("<leader>gb", builtin.git_branches)
    h.nmap("<leader>gs", builtin.git_status)
  end,
}
