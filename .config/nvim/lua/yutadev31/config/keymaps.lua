local h = require("yutadev31.utils.helper")
local telescope = require("telescope.builtin")

-- ▼ Terminal Mode
h.tmap("<ESC>", "<C-\\><C-n>")

-- ▼ Basic Operations
h.nmap("<leader>+", "<C-a>", "Increment number")
h.nmap("<leader>-", "<C-x>", "Decrement number")
h.nmap("<leader>h", function()
  require("snacks").dashboard.open({})
end, "Home Screen")
h.nmap("<leader>n", "<cmd>new<cr>", "New Buffer")
h.nmap("<leader>w", "<cmd>w<cr>", "Save")
h.nmap("<leader>q", "<cmd>q<cr>", "Quit Window")

-- ▼ Buffer Management
h.nmap("<leader>bd", "<cmd>bd<cr>", "Delete Buffer")
h.nmap("<leader>bq", "<cmd>bufdo bd<cr>", "Close All Buffers")

-- ▼ Views / Tools
h.nmap("<leader>ee", "<cmd>Oil<cr>", "Open Oil File Manager")
h.nmap("<leader>gg", "<cmd>Neogit<CR>", "Open Neogit")

-- ▼ Terminal Toggle
h.nmap("<leader>tt", "<cmd>ToggleTerm<cr>", "Toggle Terminal")

-- ▼ Package Managers
h.nmap("<leader>pm", "<cmd>Mason<cr>", "Open Mason")
h.nmap("<leader>pl", "<cmd>Lazy<cr>", "Open Lazy")

-- ▼ Telescope
h.nmap("<leader>ff", telescope.find_files, "Find Files")
h.nmap("<leader>fg", telescope.live_grep, "Live Grep")
h.nmap("<leader>fo", telescope.oldfiles, "Recent Files")
h.nmap("<leader>fb", telescope.buffers, "Open Buffers")
h.nmap("<leader>fc", telescope.commands, "Command Palette")
h.nmap("<leader>fh", telescope.help_tags, "Help Tags")
h.nmap("<leader>fd", telescope.diagnostics, "Diagnostics")
h.nmap("<leader>fr", telescope.lsp_references, "LSP References")
h.nmap("<leader>fs", telescope.lsp_document_symbols, "Document Symbols")
h.nmap("<leader>fw", telescope.lsp_workspace_symbols, "Workspace Symbols")

-- ▼ Git (Telescope)
h.nmap("<leader>gc", telescope.git_commits, "Git Commits")
h.nmap("<leader>gb", telescope.git_branches, "Git Branches")
h.nmap("<leader>gs", telescope.git_status, "Git Status")

-- ▼ LSP (Language Server Protocol)
h.nmap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition")
h.nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to Declaration")
h.nmap("gr", "<cmd>lua vim.lsp.buf.references()<cr>", "Find References")
h.nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to Implementation")
h.nmap("K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover Info")
h.nmap("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename Symbol")
h.nmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action")
h.nmap("<leader>k", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help")
