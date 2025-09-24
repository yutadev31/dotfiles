---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      format = {
        enable = false,
      },
    },
  },
  root_markers = { "stylua.toml", ".stylua.toml" },
  filetypes = { "lua" },
}
