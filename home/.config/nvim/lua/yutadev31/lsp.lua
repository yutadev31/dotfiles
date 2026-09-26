vim.lsp.inlay_hint.enable(true)

vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.config("nixd", {
  settings = {
    nixd = {
      nixpkgs = { expr = "import <nixpkgs> { }" },
      options = {
        nixos = { expr = "(builtins.getFlake (toString ./.)).nixosConfigurations.<hostname>.options" },
        home_manager = {
          expr = '(builtins.getFlake (toString ./.)).homeConfigurations."<username>@<hostname>".options',
        },
      },
    },
  },
})

vim.lsp.enable({
  "nixd",
  "pyright",
  "rust_analyzer",
  "html",
  "clangd",
  "cssls",
  "jsonls",
  "ts_ls",
  "tailwindcss",
  "taplo",
  "yamlls",
  "gopls",
  "cmake",
  "zls",
  "typos_lsp",
  "biome",
  "lua_ls",
  "stylua",
})
