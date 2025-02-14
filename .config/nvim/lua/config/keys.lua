local set = vim.keymap.set

set("n", "<leader>ee", "<CMD>Oil<CR>")
set("n", "<leader>tt", "<CMD>ToggleTerm<CR>")
set("n", "<leader>mm", "<CMD>Mason<CR>")

set("n", "<leader>fo", function()
	vim.lsp.buf.format({ async = true })
end)

set(
	"n",
	"<leader>tg",
	[[<CMD>lua require('close_buffers').delete({type = 'all'})<CR>]],
	{ noremap = true, silent = true }
)
