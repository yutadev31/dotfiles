-- ui/file.lua
local sidebar = require("yutadev31.ui.core.sidebar")

local state = {
  entries = {},
  path_map = {},
  indent_map = {},
  highlight_map = {},
  expanded = {},
  cache = {},
}

local function scan_shallow(path, cache)
  local uv = vim.uv

  if cache[path] then
    return cache[path]
  end

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

  cache[path] = entries
  return entries
end

local function render(buf)
  vim.bo[buf].modifiable = true
  local lines = {}

  -- ディレクトリを再帰的に描画
  local function render_dir(path, indent)
    local devicons = require("nvim-web-devicons")

    local entries = scan_shallow(path, state.cache)
    for _, entry in ipairs(entries) do
      local icon, hl_group

      if entry.type == "directory" then
        icon = state.expanded[entry.path] and "" or "󰉋" -- ディレクトリ用の固定アイコン（必要ならカスタムできる）
        hl_group = "Directory" -- Neovimのデフォルトのディレクトリハイライトグループ
      else
        -- ファイル名と拡張子からアイコン取得
        icon, hl_group = devicons.get_icon(entry.name, nil, { default = true })
        if not icon then
          icon = "󰈔" -- デフォルトのファイルアイコン
          hl_group = "Normal"
        end
      end

      -- ハイライト付きの行を構築（ハイライトは後でNSで設定してもOK）
      local line = string.rep("  ", indent) .. icon .. " " .. entry.name
      table.insert(lines, line)

      -- パスとインデント記録
      state.path_map[#lines] = entry.path
      state.indent_map[#lines] = indent
      state.highlight_map[#lines] = hl_group -- アイコン用のハイライトを別に記録（後で使うなら）

      -- 展開されていれば再帰
      if entry.type == "directory" and state.expanded[entry.path] then
        render_dir(entry.path, indent + 1)
      end
    end
  end

  local root = vim.fn.getcwd()
  render_dir(root, 0) -- 初期呼び出しでインデントは0
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines) -- 行を描画

  -- ハイライト追加
  local ns_id = vim.api.nvim_create_namespace("lazy_explorer")
  for i, line in ipairs(lines) do
    local indent = state.indent_map[i]
    local highlight_group = state.highlight_map[i]
    local icon = line:sub(1, 2)
    local line_length = #line

    -- アイコン部分のハイライト
    local start_pos = string.find(line, icon) + indent * 2
    local end_pos = start_pos + #icon - 1
    if start_pos and end_pos <= line_length then
      vim.api.nvim_buf_set_extmark(buf, ns_id, i - 1, start_pos - 1, {
        hl_group = highlight_group,
        end_col = end_pos + 1,
      })
    end
  end

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
    sidebar.open_file(path)
  end
end

return {
  name = "Files",
  render = render,
  keymaps = {
    ["<cr>"] = open_or_expand,
  },
}
