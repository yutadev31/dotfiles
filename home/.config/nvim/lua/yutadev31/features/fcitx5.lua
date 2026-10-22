local M = {}

function M.setup()
  if vim.fn.executable("fcitx5-remote") == 1 then
    vim.api.nvim_create_autocmd("InsertLeave", {
      callback = function()
        vim.fn.jobstart({ "fcitx5-remote", "-c" }, { detach = true })
      end,
    })
  end
end

return M
