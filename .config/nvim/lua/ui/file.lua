-- ui/file.lua
local state = {
  entries = {},
  path_map = {}, -- 行番号 => path
  expanded = {}, -- path => boolean
}

local WINDOW_NAME = "LazyFiles"
local WINDOW_WIDTH = 35

local function scan_shallow(path)
  -- キャッシュを確認
  if state.entries[path] then
    return state.entries[path]
  end

  local uv = vim.loop
  local entries = {}
  local fd = uv.fs_scandir(path)
  if not fd then
    return entries
  end

  while true do
    local name, typ = uv.fs_scandir_next(fd)
    if not name then
      break
    end
    table.insert(entries, { name = name, type = typ, path = path .. "/" .. name })
  end

  table.sort(entries, function(a, b)
    if a.type ~= b.type then
      return a.type == "directory"
    end
    return a.name < b.name
  end)

  -- キャッシュを保存
  state.entries[path] = entries
  return entries
end

local function render(buf)
  vim.bo[buf].modifiable = true
  local lines = {}

  local function render_dir(path, indent)
    local entries = scan_shallow(path)
    for _, entry in ipairs(entries) do
      local icon = entry.type == "directory" and "󰉋 " or "󰈔 "
      local line = string.rep("  ", indent) .. icon .. " " .. entry.name
      table.insert(lines, line)
      state.path_map[#lines] = entry.path

      if entry.type == "directory" and state.expanded[entry.path] then
        render_dir(entry.path, indent + 1)
      end
    end
  end

  local root = vim.fn.getcwd()
  render_dir(root, 0)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
end

local function open_or_expand()
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.fn.line(".")
  local path = state.path_map[line]
  if not path then
    return
  end

  local stat = vim.loop.fs_stat(path)
  if not stat then
    return
  end

  if stat.type == "directory" then
    state.expanded[path] = not state.expanded[path]
    render(buf)
  elseif stat.type == "file" then
    local cur_win = vim.api.nvim_get_current_win()
    vim.cmd("wincmd l")

    local new_win = vim.api.nvim_get_current_win()
    if new_win == cur_win then
      vim.cmd("vsplit")

      -- サイドバーを元のサイズに戻す
      vim.cmd("wincmd h")
      vim.cmd("vertical resize " .. WINDOW_WIDTH)
      vim.cmd("wincmd l")
    end

    vim.cmd("edit " .. vim.fn.fnameescape(path))
  end
end

local function open_lazy_files()
  local res = require("ui.window").open_sidebar(WINDOW_NAME, WINDOW_WIDTH)
  local buf = res.buf

  render(buf)

  -- キーマップ: Enter で展開/折りたたみ
  vim.keymap.set("n", "<CR>", open_or_expand, { buffer = buf, noremap = true, silent = true })
end

local M = {}

function M.setup()
  vim.api.nvim_create_user_command(WINDOW_NAME, open_lazy_files, {})
end

return M
