---@type vim.lsp.Config
return {
  settings = {
    ["rust-analyzer"] = {
      diagnostic = {
        refreshSupport = false,
      },
    },
  },
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
  root_markers = { "Cargo.toml" },
  filetypes = { "rust" },
}
