---@type vim.lsp.Config
return {
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
}
