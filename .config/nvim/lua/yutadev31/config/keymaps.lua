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
h.nmap("<leader>gg", "<cmd>Neogit<CR>")

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

-- Telescpe
local builtin = require("telescope.builtin")
h.nmap("<leader>ff", builtin.find_files)
h.nmap("<leader>fg", builtin.live_grep)
h.nmap("<leader>fb", builtin.buffers)
h.nmap("<leader>fh", builtin.help_tags)

h.nmap("<leader>fd", builtin.diagnostics)
h.nmap("<leader>fr", builtin.lsp_references)
h.nmap("<leader>fs", builtin.lsp_document_symbols)
h.nmap("<leader>fw", builtin.lsp_workspace_symbols)

h.nmap("<leader>gc", builtin.git_commits)
h.nmap("<leader>gb", builtin.git_branches)
h.nmap("<leader>gs", builtin.git_status)
