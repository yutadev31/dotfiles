local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
      vim.keymap.set("n", "q", "<cmd>cclose<cr>", {
        buffer = true,
        silent = true,
      })
    end,
  })
end

return M
