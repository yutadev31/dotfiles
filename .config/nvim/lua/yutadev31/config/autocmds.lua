vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.cmd("startinsert")
  end,
})

vim.api.nvim_create_autocmd("TermEnter", {
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.api.nvim_create_autocmd("FocusGained", { command = "checktime" }) -- 外部変更の自動検出
