local h = require("yutadev31.utils.helper")

-- Terminal
h.tmap("<ESC>", "<C-\\><C-n>")

-- LSP
h.nmap("K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover Info")
h.nmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename Symbol")
h.nmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action")

h.nmap("<leader>ee", "<cmd>Oil<cr>", "Open file explorer")

h.nmap("<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics")
h.nmap("<leader>xq", "<cmd>Trouble qflist toggle<cr>", "Quickfix")
h.nmap("<leader>xl", "<cmd>Trouble loclist toggle<cr>", "Location List")
h.nmap("<leader>xt", "<cmd>Trouble todo toggle<cr>", "Todo")

local t = require("yutadev31.terminal")
h.nmap("<leader>tt", t.toggle)
