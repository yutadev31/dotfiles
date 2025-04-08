-- ▼ 基本設定
vim.g.mapleader = " "       -- リーダーキー設定
vim.g.maplocalleader = "\\" -- ローカルリーダーキー設定
vim.opt.encoding = "utf-8"
vim.opt.title = true
vim.opt.termguicolors = true                  -- 24bitカラー対応
vim.opt.completeopt = "menu,menuone,noselect" -- 補完の挙動
vim.opt.timeout = true
vim.opt.timeoutlen = 1000
vim.opt.shell = "/usr/bin/fish"

-- ▼ 表示設定
vim.opt.number = true               -- 行番号表示
vim.opt.relativenumber = true       -- 相対行番号表示
vim.opt.cursorline = true           -- カーソル行をハイライト
vim.opt.scrolloff = 5               -- スクロール時の余白
vim.opt.laststatus = 3              -- ステータスラインを全ウィンドウで統一
vim.opt.winblend = 0                -- ウィンドウの透明度
vim.opt.pumblend = 0                -- ポップアップメニューの透明度
vim.opt.wrap = true                 -- 行の折り返しを有効化
vim.opt.linebreak = true            -- 単語の途中で折り返さない
vim.opt.whichwrap:append("<,>,h,l") -- 折り返しをまたいで移動

-- ▼ インデント設定
vim.opt.expandtab = true   -- タブをスペースに変換
vim.opt.shiftwidth = 2     -- インデント幅
vim.opt.tabstop = 2        -- タブの幅
vim.opt.softtabstop = 2    -- バックスペースでの削除幅
vim.opt.autoindent = true  -- 自動インデント
vim.opt.smartindent = true -- スマートインデント

-- ▼ 検索設定
vim.opt.ignorecase = true -- 大文字小文字を区別しない
vim.opt.smartcase = true  -- ただし大文字が含まれている場合は区別
vim.opt.hlsearch = true   -- 検索結果をハイライト

-- ▼ クリップボード共有
vim.opt.clipboard = "unnamedplus" -- システムクリップボードと連携

-- ▼ 不可視文字の表示設定
vim.opt.list = true
vim.opt.listchars = { tab = "> ", trail = "-", nbsp = "+" }

-- ▼ バックスペースの挙動改善
vim.opt.backspace = "indent,eol,start"

-- ▼ 補完時の挙動をスムーズに
vim.opt.shortmess:append("c")
vim.opt.updatetime = 300

-- ▼ スワップファイル無効化
vim.opt.swapfile = false

-- ▼ 外部変更の自動検出
vim.opt.autoread = true

-- ▼ ウィンドウの挙動を改善
vim.opt.splitright = true -- 縦分割を右側に
vim.opt.splitbelow = true -- 横分割を下側に
vim.opt.showmode = false  -- ステータスラインを使うなら非表示
vim.opt.cmdheight = 0

-- ▼ カラースキーム
vim.cmd("colorscheme onenord")
