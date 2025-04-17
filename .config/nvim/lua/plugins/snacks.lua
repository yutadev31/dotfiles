return {
  "folke/snacks.nvim",
  opts = {
    indent = {
      priority = 1,
      enabled = true,
      char = "│",
      only_scope = false,
      only_current = false,
      hl = "SnacksIndent",
    },
    animate = {
      enabled = false,
      style = "out",
      easing = "linear",
      duration = {
        step = 0,
        total = 0,
      },
    },
    scope = {
      enabled = true,
      priority = 200,
      char = "│",
      underline = false,
      only_current = false,
      hl = "SnacksIndentScope",
    },
    chunk = {
      enabled = false,
      only_current = false,
      priority = 200,
      hl = "SnacksIndentChunk",
      char = {
        corner_top = "┌",
        corner_bottom = "└",
        horizontal = "─",
        vertical = "│",
        arrow = ">",
      },
    },
  },
}
