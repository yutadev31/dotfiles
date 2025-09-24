---@type vim.lsp.Config
return {
  filetypes = { "html" },
  root_markers = { "package.json" },
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { "html", "css", "javascript" },
  },
}
