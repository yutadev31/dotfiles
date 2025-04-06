return {
  {
    "saecki/crates.nvim",
    tag = "stable",
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  -- {
  --   "mrcjkb/rustaceanvim",
  --   version = "^6",
  --   lazy = false,
  -- },
}
