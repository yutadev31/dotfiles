return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    config = function()
      require("mason").setup({
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
      })
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
