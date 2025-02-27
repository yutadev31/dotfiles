local set = vim.keymap.set

set("n", "<leader>ee", "<CMD>Oil<CR>")
set("n", "<leader>tt", "<CMD>ToggleTerm<CR>")
set("n", "<leader>tb", function()
  vim.cmd("split | terminal")
  vim.cmd("resize 10")
end)

set("n", "<leader>mm", "<CMD>Mason<CR>")

set("n", "<leader>fo", function()
  vim.lsp.buf.format({ async = true })
end)

-- Terminal mode to normal mode
set("t", "<ESC>", "<C-\\><C-n>")

-- telescope
local builtin = require("telescope.builtin")

set("n", "<leader>ff", builtin.find_files, { desc = "ファイル検索" })
set("n", "<leader>fg", builtin.live_grep, { desc = "単語検索" })
set("n", "<leader>fb", builtin.buffers, { desc = "開いているバッファ一覧" })
set("n", "<leader>fh", builtin.help_tags, { desc = "ヘルプ検索" })

-- LSP関連
set("n", "<leader>fr", builtin.lsp_references, { desc = "シンボルの参照一覧" })
set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "ファイル内のシンボル検索" })
set("n", "<leader>fw", builtin.lsp_workspace_symbols, { desc = "ワークスペース全体のシンボル検索" })

-- Git関連 (Gitプラグインが必要)
set("n", "<leader>gc", builtin.git_commits, { desc = "Gitコミット履歴" })
set("n", "<leader>gb", builtin.git_branches, { desc = "Gitブランチ一覧" })
set("n", "<leader>gs", builtin.git_status, { desc = "Gitの変更ファイル" })

local opts = { noremap = true, silent = true }

-- LSP基本操作
set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)          -- 定義へジャンプ
set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)         -- 宣言へジャンプ
set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)          -- 参照を検索
set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)      -- 実装へジャンプ
set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)                -- ドキュメント表示
set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)      -- 変数リネーム
set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- コードアクション
