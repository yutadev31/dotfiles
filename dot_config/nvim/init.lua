require("config.lazy")

require("onedark").load()

vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.encoding = "utf-8"
vim.opt.title = true
vim.opt.termguicolors = true
vim.opt.completeopt = "menu,menuone,noselect"
vim.g.neovide_padding_top = 4
vim.g.neovide_padding_bottom = 4
vim.o.timeout = true
vim.o.timeoutlen = 400
vim.opt.laststatus = 3
vim.opt.tabstop = 2

local set = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

set("n", "<C-n>", ":Neotree <CR>")
set("n", "<C-h>", ":bprev<CR>")
set("n", "<C-l>", ":bnext<CR>")
set("n", "<C-g>", function()
	vim.lsp.buf.format({ async = true })
end)

autocmd("TermOpen", {
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.cmd("startinsert")
	end,
})
