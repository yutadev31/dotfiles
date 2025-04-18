-- ui/window.lua
local M = {}

function M.open_sidebar(title, width)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, title)

  vim.cmd("topleft vnew")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_win_set_width(win, width)

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false

  return {
    buf = buf,
    win = win,
  }
end

return M
