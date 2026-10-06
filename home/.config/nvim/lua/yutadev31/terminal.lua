local M = {}

local state = {
  buf = nil,
  win = nil,
}

local function window_config()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  return {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "single",
  }
end

local function create_window(buf)
  return vim.api.nvim_open_win(buf, true, window_config())
end

vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
      vim.api.nvim_win_set_config(state.win, window_config())
    end
  end,
})

function M.toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
    return
  end

  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
    state.win = create_window(state.buf)

    vim.fn.jobstart(vim.o.shell, {
      term = true,
      on_exit = function()
        vim.schedule(function()
          if state.win and vim.api.nvim_win_is_valid(state.win) then
            vim.api.nvim_win_close(state.win, true)
          end

          if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
            vim.api.nvim_buf_delete(state.buf, { force = true })
          end

          state.win = nil
          state.buf = nil
        end)
      end,
    })

    vim.cmd("startinsert")
    return
  end

  state.win = create_window(state.buf)
  vim.cmd("startinsert")
end

return M
