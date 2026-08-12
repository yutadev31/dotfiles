return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      html = { "biome-check", "oxfmt" },
      css = { "biome-check", "oxfmt" },
      json = { "biome-check", "oxfmt" },
      javascript = { "biome-check", "oxfmt" },
      javascriptreact = { "biome-check", "oxfmt" },
      typescript = { "biome-check", "oxfmt" },
      typescriptreact = { "biome-check", "oxfmt" },
      nix = { "nixfmt" },
      go = { "gofmt" },
      asm = { "asmfmt" },
      make = { "bake" },
    },
    format_on_save = {
      timeout_ms = 2000,
      lsp_fallback = true,
      quiet = false,
    },
  },
}
