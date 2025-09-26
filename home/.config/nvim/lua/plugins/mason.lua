return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "clangd",
        "lua-language-server",
        "rust-analyzer",
        "pyright",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "typescript-language-server",
        "bash-language-server",
        "fish-lsp",
      },
    },
    config = function(opts)
      require("mason").setup(opts)
      vim.lsp.enable({
        "bashls",
        "clangd",
        "cssls",
        "fish_lsp",
        "html",
        "jsonls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "ts_ls",
        "nil_ls",
      })
    end,
  },
}
