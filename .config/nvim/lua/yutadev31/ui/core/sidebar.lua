local M = {}

local width = 35

function M.open(view)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, view.name)

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

  view.render(buf)

  for key, action in pairs(view.keymaps or {}) do
    vim.keymap.set("n", key, action, { buffer = buf, noremap = true, silent = true })
  end

  vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = buf, noremap = true, silent = true })
end

function M.open_file(path)
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd l")

  local new_win = vim.api.nvim_get_current_win()
  if new_win == cur_win then
    vim.cmd("vsplit")

    -- サイドバーを元のサイズに戻す
    vim.cmd("wincmd h")
    vim.api.nvim_win_set_width(new_win, width)
    vim.cmd("wincmd l")
  end

  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

return M
