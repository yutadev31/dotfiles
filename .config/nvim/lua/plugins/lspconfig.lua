return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  lazy = false,
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local ensure_installed = {
      -- c/c++ --
      "clangd",
      "clang-format",

      -- rust --
      "rust-analyzer",

      -- lua --
      "lua-language-server",
      "stylua",

      -- python --
      "pyright",
      "black",

      -- web --
      "html-lsp",
      "css-lsp",
      "json-lsp",
      "typescript-language-server",
      "astro-language-server",
      "prettierd",
    }

    require("mason").setup()
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
    require("mason-lspconfig").setup({})

    require("mason-lspconfig").setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
        })
      end,
      ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup({
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
              },
            },
          },
        })
      end,
      ["rust_analyzer"] = function()
        require("lspconfig").rust_analyzer.setup({
          capabilities = capabilities,
          settings = {
            ["rust-analyzer"] = {
              diagnostic = {
                refreshSupport = false,
              },
            },
          },
        })
      end,
    })
  end,
}
