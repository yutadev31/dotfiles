local h = require("yutadev31.utils.helper")

-- Terminal
h.tmap("<ESC>", "<C-\\><C-n>")

-- LSP
h.nmap("K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover Info")
h.nmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename Symbol")
h.nmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action")

local t = require("yutadev31.terminal")
h.nmap("<leader>tt", t.toggle)
