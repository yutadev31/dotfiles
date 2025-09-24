---@type vim.lsp.Config
return {
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json" },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}
