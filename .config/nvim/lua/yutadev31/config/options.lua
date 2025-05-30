local h = require("yutadev31.utils.helper")

-- Basic Settings
vim.opt.encoding = "utf-8"
vim.opt.title = true
vim.opt.termguicolors = true
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.timeout = true
vim.opt.timeoutlen = 1000
vim.opt.shell = "/usr/bin/fish"

-- UI / Display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.laststatus = 3
vim.opt.winblend = 0
vim.opt.pumblend = 0
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.whichwrap:append("<,>,h,l")
vim.opt.fillchars:append({ eob = "~" })

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Search Behavior
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Clipboard Integration
vim.opt.clipboard:append("unnamedplus")

-- Whitespace Characters
vim.opt.list = true
vim.opt.listchars = { tab = "> ", trail = "-", nbsp = "+" }

-- Backspace Behavior
vim.opt.backspace = "indent,eol,start"

-- Completion & Performance
vim.opt.shortmess:append("c")
vim.opt.updatetime = 300

-- Disable Swap Files
vim.opt.swapfile = false

-- Auto Reload on File Change
vim.opt.autoread = true

-- Window Split Behavior
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.showmode = false
vim.opt.cmdheight = 0

-- Folding (with Treesitter)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldenable = true

-- Colorscheme
vim.cmd("colorscheme shadow-hue")

-- Filetype-specific Tab Settings
h.filetype({ "rust", "php", "python" }, function()
  h.tabsize(true, 4)
end)

h.filetype({ "go", "make", "cpp", "java" }, function()
  h.tabsize(false, 4)
end)

-- Auto start insert mode & hide line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.cmd("startinsert")
  end,
})

-- Ensure insert mode when entering terminal buffer
vim.api.nvim_create_autocmd("TermEnter", {
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- Format on save (synchronously)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Auto-reload files changed outside of Neovim
vim.api.nvim_create_autocmd("FocusGained", {
  command = "checktime",
})
