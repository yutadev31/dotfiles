require("config.lazy")
require("config.keys")

vim.cmd("colorscheme dracula")

-- 行番号を表示
vim.opt.number = true

-- インデントの設定
vim.opt.expandtab = true   -- タブをスペースに
vim.opt.shiftwidth = 2     -- インデント幅
vim.opt.tabstop = 2        -- タブの幅
vim.opt.smartindent = true -- スマートインデント

-- 検索の設定
vim.opt.ignorecase = true -- 大文字小文字を区別しない
vim.opt.smartcase = true  -- ただし大文字が含まれている場合は区別する
vim.opt.hlsearch = true   -- 検索結果をハイライト

-- クリップボード共有（システムクリップボードと連携）
vim.opt.clipboard = "unnamedplus"

-- カーソルラインをハイライト
vim.opt.cursorline = true

-- スクロール時に余白を確保
vim.opt.scrolloff = 5

vim.opt.encoding = "utf-8"
vim.opt.title = true
vim.opt.termguicolors = true
vim.opt.completeopt = "menu,menuone,noselect"
vim.g.mapleader = " "
vim.o.timeout = true
vim.o.timeoutlen = 400
vim.opt.laststatus = 3

vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.pumblend = 0

vim.opt.list = true
vim.opt.listchars = { tab = ">>", trail = "-", nbsp = "+" }
