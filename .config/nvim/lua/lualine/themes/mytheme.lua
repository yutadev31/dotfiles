local colors = require("mytheme.colors")

local M = {}

M.normal = {
  a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
  b = { fg = colors.blue, bg = colors.currentline },
  c = { fg = colors.white, bg = colors.statusline },
}

M.insert = {
  a = { fg = colors.bg, bg = colors.green, gui = "bold" },
  b = { fg = colors.green, bg = colors.currentline },
  c = { fg = colors.white, bg = colors.statusline },
}

M.command = {
  a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
  b = { fg = colors.yellow, bg = colors.currentline },
  c = { fg = colors.white, bg = colors.statusline },
}

M.visual = {
  a = { fg = colors.bg, bg = colors.purple, gui = "bold" },
  b = { fg = colors.purple, bg = colors.currentline },
  c = { fg = colors.white, bg = colors.statusline },
}

M.replace = {
  a = { fg = colors.bg, bg = colors.red, gui = "bold" },
  b = { fg = colors.red, bg = colors.currentline },
  c = { fg = colors.white, bg = colors.statusline },
}

return M
