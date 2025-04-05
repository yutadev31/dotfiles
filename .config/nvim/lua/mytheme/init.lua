local M = {}

function M.load()
  local colors = require("mytheme.colors")

  local theme = {
    Normal = { fg = colors.fg, bg = colors.bg },

    ["@comment"] = { fg = colors.white },
    ["@keyword"] = { fg = colors.red },
    ["@string"] = { fg = colors.green },
    ["@module"] = { fg = colors.yellow },
    ["@type"] = { fg = colors.orange },
    ["@function"] = { fg = colors.purple },
    ["@variable"] = { fg = colors.fg },
    ["@variable.builtin"] = { fg = colors.red },
    ["@constant"] = { fg = colors.fg },
    ["@property"] = { fg = colors.cyan },
    ["@constant.enumMember"] = { fg = colors.cyan },
    ["@boolean"] = { fg = colors.blue },
    ["@number"] = { fg = colors.emerald },

    ["@lsp.type.enumMember"] = { link = "@constant.enumMember" },
    ["@lsp.type.macro"] = { link = "@function.macro" },
  }

  vim.cmd("hi clear")
  for group, value in pairs(theme) do
    vim.api.nvim_set_hl(0, group, value)
  end
end

return M
