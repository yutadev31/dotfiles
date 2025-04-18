-- ui/window.lua
local M = {}

function M.open_sidebar(title, width)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, title)

  vim.cmd("topleft vnew")
  local tmp_buf = vim.api.nvim_get_current_buf()
  vim.bo[tmp_buf].buftype = "nofile"
  vim.bo[tmp_buf].buflisted = false
  vim.bo[tmp_buf].swapfile = false
  vim.bo[tmp_buf].bufhidden = "wipe"

  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_win_set_width(win, width)

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false

  vim.wo[win].wrap = false
  vim.wo[win].sidescrolloff = 2
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false

  return {
    buf = buf,
    win = win,
  }
end

return M
