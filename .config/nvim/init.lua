require("config.lazy")
require("config.keys")

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
