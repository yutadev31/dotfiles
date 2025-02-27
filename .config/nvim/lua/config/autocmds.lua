vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.wo.number = false
    vim.cmd("startinsert")
  end,
})

vim.api.nvim_create_autocmd("FocusGained", { command = "checktime" }) -- 外部変更の自動検出
