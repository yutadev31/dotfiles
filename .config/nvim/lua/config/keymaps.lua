local set = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ▼ ファイラー・ターミナル
set("n", "<leader>ee", "<CMD>Oil<CR>", { desc = "ファイラーを開く" })
set("n", "<leader>nn", "<CMD>Neotree<CR>")
set("n", "<leader>tt", "<CMD>ToggleTerm<CR>", { desc = "ターミナルをトグル" })
set("n", "<leader>tm", function()
  vim.cmd("terminal")
end, { desc = "ターミナルを開く" })
set("n", "<leader>tb", function()
  vim.cmd("split | terminal")
  vim.cmd("resize 10")
end, { desc = "下部にターミナルを開く" })

-- ▼ Mason（LSP・ツール管理）
set("n", "<leader>mm", "<CMD>Mason<CR>", { desc = "Mason を開く" })

-- ▼ ターミナルモードのESCキーでノーマルモードへ
set("t", "<ESC>", "<C-\\><C-n>", { desc = "ターミナルモード終了" })

-- ▼ Telescope (ファイル・検索系)
local builtin = require("telescope.builtin")

set("n", "<leader>ff", builtin.find_files, { desc = "ファイル検索" })
set("n", "<leader>fg", builtin.live_grep, { desc = "単語検索" })
set("n", "<leader>fb", builtin.buffers, { desc = "開いているバッファ一覧" })
set("n", "<leader>fh", builtin.help_tags, { desc = "ヘルプ検索" })

-- ▼ LSP関連
set("n", "<leader>fr", builtin.lsp_references, { desc = "シンボルの参照一覧" })
set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "ファイル内のシンボル検索" })
set("n", "<leader>fw", builtin.lsp_workspace_symbols, { desc = "ワークスペース全体のシンボル検索" })

-- ▼ Git関連
set("n", "<leader>gc", builtin.git_commits, { desc = "Gitコミット履歴" })
set("n", "<leader>gb", builtin.git_branches, { desc = "Gitブランチ一覧" })
set("n", "<leader>gs", builtin.git_status, { desc = "Gitの変更ファイル" })

-- ▼ LSP基本操作
set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)          -- 定義へジャンプ
set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)         -- 宣言へジャンプ
set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)          -- 参照を検索
set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)      -- 実装へジャンプ
set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)                -- ドキュメント表示
set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)      -- 変数リネーム
set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- コードアクション
