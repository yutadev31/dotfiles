require("config.lazy")

require("onedark").load()

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.encoding = "utf-8"
vim.opt.title = true
vim.opt.termguicolors = true
vim.opt.completeopt = "menu,menuone,noselect"
vim.g.mapleader = " "
vim.o.timeout = true
vim.o.timeoutlen = 400
vim.opt.laststatus = 3
vim.opt.clipboard = "unnamedplus"

local set = vim.keymap.set

set("n", "<leader>ee", "<CMD>Oil<CR>")
set("n", "<leader>tt", "<CMD>ToggleTerm<CR>")

set("n", "<leader>ff", function()
	vim.lsp.buf.format({ async = true })
end)

set(
	'n',
	'<leader>tg',
	[[<CMD>lua require('close_buffers').delete({type = 'all'})<CR>]],
	{ noremap = true, silent = true }
)
