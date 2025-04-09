local M = {}

function M.load()
  local colors = require("mytheme.colors")

  local theme = {
    Cursor = { fg = colors.white },
    CursorLine = { bg = colors.currentline },
    Directory = { fg = colors.blue },
    EndOfBuffer = { fg = colors.gray },
    WinSeparator = { fg = colors.gray },
    LineNr = { fg = colors.gray },
    CursorLineNr = { fg = colors.white },
    Normal = { fg = colors.white, bg = colors.bg },
    Comment = { fg = colors.gray },
    Constant = { fg = colors.blue },
    String = { fg = colors.green },
    Character = { fg = colors.green },
    Number = { fg = colors.orange },
    Boolean = { fg = colors.orange },
    Float = { fg = colors.orange },
    Identifier = { fg = colors.white },
    Function = { fg = colors.blue },
    Keyword = { fg = colors.pink },
    PreProc = { fg = colors.pink },
    Include = { fg = colors.blue },
    Define = { fg = colors.red },
    Macro = { fg = colors.red },
    PreCondit = { fg = colors.pink },
    Type = { fg = colors.yellow },
    StorageClass = { fg = colors.pink },
    Structure = { fg = colors.pink },
    Typedef = { fg = colors.pink },
    Special = { fg = colors.red },
    SpecialChar = { fg = colors.red },
    Tag = { fg = colors.green },
    Delimiter = { fg = colors.indigo },
    SpecialComment = { fg = colors.gray },
    Debug = { fg = colors.yellow },
    Underlined = { fg = colors.green },
    Ignore = { fg = colors.blue },
    Error = { fg = colors.red, underline = true },
    Todo = { fg = colors.yellow, underline = true },
    Added = { fg = colors.emerald },
    Changed = { fg = colors.blue },
    Removed = { fg = colors.fuchsia },

    -- ["@comment"] = { fg = colors.white },
    -- ["@keyword"] = { fg = colors.red },
    -- ["@string"] = { fg = colors.green },
    -- ["@module"] = { fg = colors.yellow },
    -- ["@type"] = { fg = colors.orange },
    -- ["@function"] = { fg = colors.purple },
    -- ["@variable"] = { fg = colors.fg },
    -- ["@variable.builtin"] = { fg = colors.red },
    -- ["@constant"] = { fg = colors.fg },
    -- ["@property"] = { fg = colors.cyan },
    -- ["@constant.enumMember"] = { fg = colors.cyan },
    -- ["@boolean"] = { fg = colors.blue },
    -- ["@number"] = { fg = colors.emerald },
    --
    -- ["@lsp.type.enumMember"] = { link = "@constant.enumMember" },
    -- ["@lsp.type.macro"] = { link = "@function.macro" },
  }

  vim.cmd("hi clear")
  for group, value in pairs(theme) do
    vim.api.nvim_set_hl(0, group, value)
  end
end

return M
