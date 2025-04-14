local h = require("utils.helper")

-- ▼ ターミナルモードのESCキーでノーマルモードへ
h.tmap("<ESC>", "<C-\\><C-n>")
h.nmap("<leader>nh", "<cmd>nohl<cr>")
h.nmap("<leader>+", "<C-a>")
h.nmap("<leader>-", "<C-x>")

h.imap("<c-space>", function()
  vim.lsp.completion.get()
end)

h.nmap("<leader>ee", "<cmd>Oil<cr>")
h.nmap("<leader>tt", "<cmd>ToggleTerm<cr>")
h.nmap("<leader>mm", "<cmd>Mason<cr>")

h.nmap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
h.nmap("gd", "<cmd>lua vim.lsp.buf.declaration()<cr>")
h.nmap("gr", "<cmd>lua vim.lsp.buf.references()<cr>")
h.nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
h.nmap("K", "<cmd>lua vim.lsp.buf.hover()<cr>")
h.nmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")
h.nmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
