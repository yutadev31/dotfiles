local h = require("utils.helper")

-- ▼ ターミナルモードのESCキーでノーマルモードへ
h.tmap("<ESC>", "<C-\\><C-n>")

h.imap("<c-space>", function()
  vim.lsp.completion.get()
end)

h.nmap("<leader>ee", "<CMD>Oil<CR>")
h.nmap("<leader>tt", "<CMD>ToggleTerm<CR>")
h.nmap("<leader>mm", "<CMD>Mason<CR>")

h.nmap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
h.nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
h.nmap("gr", "<cmd>lua vim.lsp.buf.references()<CR>")
h.nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
h.nmap("K", "<cmd>lua vim.lsp.buf.hover()<CR>")
h.nmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
h.nmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
