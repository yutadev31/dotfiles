local h = require("utils.helper")
local opts = { noremap = true, silent = true }

-- ▼ ターミナルモードのESCキーでノーマルモードへ
h.tmap("<ESC>", "<C-\\><C-n>")

h.imap("<c-space>", function()
  vim.lsp.completion.get()
end)

h.nmap("<leader>ee", "<CMD>Oil<CR>")
h.nmap("<leader>tt", "<CMD>ToggleTerm<CR>")
h.nmap("<leader>mm", "<CMD>Mason<CR>")

-- ▼ LSP基本操作
h.nmap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)          -- 定義へジャンプ
h.nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)         -- 宣言へジャンプ
h.nmap("gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)          -- 参照を検索
h.nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)      -- 実装へジャンプ
h.nmap("K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)                -- ドキュメント表示
h.nmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)      -- 変数リネーム
h.nmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- コードアクション
