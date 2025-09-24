---@type vim.lsp.Config
return {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  root_markers = { "pyproject.toml", "setup.py", "requirements.txt" },
  filetypes = { "python" },
}
