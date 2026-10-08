return {
  "vyfor/cord.nvim",
  config = function()
    require("cord").setup({
      discord = {
        reconnect = {
          enabled = true,
        },
      },
      display = {
        view = "asset",
        theme = "default",
        flavor = "accent",
      },
      assets = {
        oil = {
          name = "Oil",
          icon = require("cord.api.icon").get("folder", "default", "accent"),
          tooltip = "oil.nvim",
          type = "file_browser",
        },
      },
    })
  end,
}
