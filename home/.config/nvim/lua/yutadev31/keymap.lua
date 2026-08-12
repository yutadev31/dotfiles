local h = require("yutadev31.utils.helper")

-- Terminal
h.tmap("<ESC>", "<C-\\><C-n>")

-- LSP
h.nmap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition")
h.nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to Declaration")
h.nmap("gr", "<cmd>lua vim.lsp.buf.references()<cr>", "Find References")
h.nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to Implementation")
h.nmap("go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to Type Definition")
h.nmap("K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover Info")
h.nmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename Symbol")
h.nmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action")

h.nmap("<leader>ee", "<cmd>Oil<cr>", "Open file explorer")
h.nmap("<leader>tt", "<cmd>ToggleTerm<cr>", "Open terminal")

h.nmap("<leader>ff", "<cmd>Telescope find_files<cr>", "Find files")
h.nmap("<leader>fg", "<cmd>Telescope live_grep<cr>", "Live grep")
h.nmap("<leader>fb", "<cmd>Telescope buffers<cr>", "Find buffers")
h.nmap("<leader>fs", "<cmd>Telescope treesitter<cr>", "Find symbols")
h.nmap("<leader>glg", "<cmd>Telescope git_commits<cr>", "Find Git commits")
h.nmap("<leader>glb", "<cmd>Telescope git_bcommits<cr>", "Find Git commits")

h.nmap("<leader>gg", "<cmd>Neogit<cr>", "Open Neogit")

h.nmap("<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics")
h.nmap("<leader>xq", "<cmd>Trouble qflist toggle<cr>", "Quickfix")
h.nmap("<leader>xl", "<cmd>Trouble loclist toggle<cr>", "Location List")
h.nmap("<leader>xt", "<cmd>Trouble todo toggle<cr>", "Todo")

h.nmap("<leader>a", "<cmd>AerialToggle!<cr>", "Toggle Aerial")
h.nmap("{", "<cmd>AerialPrev<cr>")
h.nmap("}", "<cmd>AerialNext<cr>")
