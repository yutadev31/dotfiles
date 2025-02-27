vim.opt.swapfile = false -- スワップファイル無効化
vim.opt.undofile = true  -- Undo履歴を保存
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.autoread = true  -- 外部変更を自動で読み込む
