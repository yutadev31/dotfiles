local h = require("yutadev31.utils.helper")

-- ▼ ターミナルモードのESCキーでノーマルモードへ
h.tmap("<ESC>", "<C-\\><C-n>")
h.nmap("<leader>+", "<C-a>")
h.nmap("<leader>-", "<C-x>")

h.nmap("<leader>h", function()
  require("snacks").dashboard.open({})
end)
h.nmap("<leader>n", "<cmd>new<cr>")
h.nmap("<leader>w", "<cmd>w<cr>")
h.nmap("<leader>q", "<cmd>q<cr>")

h.nmap("<leader>ee", "<cmd>Oil<cr>")

-- Terminal
h.nmap("<leader>tt", "<cmd>ToggleTerm<cr>")

-- Package
h.nmap("<leader>pm", "<cmd>Mason<cr>")
h.nmap("<leader>pl", "<cmd>Lazy<cr>")

-- LSP
h.nmap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
h.nmap("gd", "<cmd>lua vim.lsp.buf.declaration()<cr>")
h.nmap("gr", "<cmd>lua vim.lsp.buf.references()<cr>")
h.nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
h.nmap("K", "<cmd>lua vim.lsp.buf.hover()<cr>")
h.nmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")
h.nmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
