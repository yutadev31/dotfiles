local set = vim.keymap.set

set("n", "<leader>ee", "<CMD>Oil<CR>")
set("n", "<leader>tt", "<CMD>ToggleTerm<CR>")
set("n", "<leader>tb", function()
  vim.cmd("belowright split | terminal")
  vim.cmd("resize 10")
end)

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.wo.number = false
    vim.cmd("startinsert")
  end,
})

set("n", "<leader>mm", "<CMD>Mason<CR>")

set("n", "<leader>fo", function()
  vim.lsp.buf.format({ async = true })
end)

set("t", "<ESC>", "<C-\\><C-n>")

local builtin = require("telescope.builtin")
set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
