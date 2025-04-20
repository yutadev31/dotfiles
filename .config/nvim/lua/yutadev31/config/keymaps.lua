local h = require("yutadev31.utils.helper")
local builtin = require("telescope.builtin")

-- ▼ ターミナルモードのESCキーでノーマルモードへ
h.tmap("<ESC>", "<C-\\><C-n>")

-- Basic operations
h.nmap("<leader>+", "<C-a>", "Increment number")
h.nmap("<leader>-", "<C-x>", "Decrement number")
h.nmap("<leader>h", function()
  require("snacks").dashboard.open({})
end, "Home Screen")
h.nmap("<leader>n", "<cmd>new<cr>", "New Buffer")
h.nmap("<leader>w", "<cmd>w<cr>", "Save")
h.nmap("<leader>q", "<cmd>q<cr>", "Quit Window")

-- Buffer
h.nmap("<leader>bd", "<cmd>bd<cr>", "Delete Buffer")
h.nmap("<leader>bq", "<cmd>bufdo bd<cr>", "Close All Buffers")

-- Views
h.nmap("<leader>ee", "<cmd>Oil<cr>", "Open Oil File Manager")
h.nmap("<leader>gg", "<cmd>Neogit<CR>", "Open Neogit")

-- Terminal
h.nmap("<leader>tt", "<cmd>ToggleTerm<cr>", "Toggle Terminal")

-- Package
h.nmap("<leader>pm", "<cmd>Mason<cr>", "Open Mason")
h.nmap("<leader>pl", "<cmd>Lazy<cr>", "Open Lazy")

-- LSP
h.nmap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition")
h.nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to Declaration")
h.nmap("gr", "<cmd>lua vim.lsp.buf.references()<cr>", "Find References")
h.nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to Implementation")
h.nmap("K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover Info")
h.nmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename Symbol")
h.nmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action")
h.nmap("<leader>k", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help")

-- Telescope
h.nmap("<leader>ff", builtin.find_files, "Find Files")
h.nmap("<leader>fg", builtin.live_grep, "Live Grep")
h.nmap("<leader>fo", builtin.oldfiles, "Recent Files")
h.nmap("<leader>fb", builtin.buffers, "Open Buffers")
h.nmap("<leader>fc", builtin.commands, "Command Palette")
h.nmap("<leader>fh", builtin.help_tags, "Help Tags")
h.nmap("<leader>fd", builtin.diagnostics, "Diagnostics")
h.nmap("<leader>fr", builtin.lsp_references, "LSP References")
h.nmap("<leader>fs", builtin.lsp_document_symbols, "Document Symbols")
h.nmap("<leader>fw", builtin.lsp_workspace_symbols, "Workspace Symbols")

-- Git
h.nmap("<leader>gc", builtin.git_commits, "Git Commits")
h.nmap("<leader>gb", builtin.git_branches, "Git Branches")
h.nmap("<leader>gs", builtin.git_status, "Git Status")
