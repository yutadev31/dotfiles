local h = require("utils.helper")
local opts = { noremap = true, silent = true }

-- ▼ ファイラー・ターミナル
h.nmap("<leader>ee", "<CMD>Oil<CR>", { desc = "ファイラーを開く" })
h.nmap("<leader>nn", "<CMD>Neotree<CR>")
h.nmap("<leader>tt", "<CMD>ToggleTerm<CR>", { desc = "ターミナルをトグル" })

-- ▼ Mason（LSP・ツール管理）
h.nmap("<leader>mm", "<CMD>Mason<CR>", { desc = "Mason を開く" })

-- ▼ ターミナルモードのESCキーでノーマルモードへ
h.tmap("<ESC>", "<C-\\><C-n>", { desc = "ターミナルモード終了" })

-- ▼ Telescope (ファイル・検索系)
local builtin = require("telescope.builtin")

h.nmap("<leader>ff", builtin.find_files, { desc = "ファイル検索" })
h.nmap("<leader>fg", builtin.live_grep, { desc = "単語検索" })
h.nmap("<leader>fb", builtin.buffers, { desc = "開いているバッファ一覧" })
h.nmap("<leader>fh", builtin.help_tags, { desc = "ヘルプ検索" })

-- ▼ LSP関連
h.nmap("<leader>fd", builtin.diagnostics, { desc = "エラー一覧" })
h.nmap("<leader>fr", builtin.lsp_references, { desc = "シンボルの参照一覧" })
h.nmap("<leader>fs", builtin.lsp_document_symbols, { desc = "ファイル内のシンボル検索" })
h.nmap("<leader>fw", builtin.lsp_workspace_symbols, { desc = "ワークスペース全体のシンボル検索" })

-- ▼ Git関連
h.nmap("<leader>gc", builtin.git_commits, { desc = "Gitコミット履歴" })
h.nmap("<leader>gb", builtin.git_branches, { desc = "Gitブランチ一覧" })
h.nmap("<leader>gs", builtin.git_status, { desc = "Gitの変更ファイル" })

-- ▼ LSP基本操作
h.nmap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)          -- 定義へジャンプ
h.nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)         -- 宣言へジャンプ
h.nmap("gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)          -- 参照を検索
h.nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)      -- 実装へジャンプ
h.nmap("K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)                -- ドキュメント表示
h.nmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)      -- 変数リネーム
h.nmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- コードアクション
