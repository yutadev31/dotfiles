local c = {
  bg = "#1b2127",
  gray = "#bbbbbb",
  red = "#d65c5c",
  orange = "#d69d5c",
  yellow = "#ced65c",
  lime = "#8dd65c",
  green = "#5cd66c",
  teal = "#5cd6ad",
  sky = "#5cbed6",
  indigo = "#5c7cd6",
  purple = "#7c5cd6",
  fuchsia = "#be5cd6",
  pink = "#d65cad",
  rose = "#d65c6c",
}

local highlight = {
  Comment = { fg = c.gray },
}

local set_hl = function(tbl)
  for group, conf in pairs(tbl) do
    vim.api.nvim_set_hl(0, group, conf)
  end
end

vim.g.colors_name = "moon-theme"
vim.cmd.highlight("clear")
vim.o.background = "dark"

set_hl(highlight)
