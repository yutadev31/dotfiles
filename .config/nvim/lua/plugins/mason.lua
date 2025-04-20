return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "lua-language-server",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    event = "VeryLazy",
    config = function()
      require("mason-lspconfig").setup({
        automatic_installation = true,
      })

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({})
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
                format = {
                  enable = false,
                },
              },
            },
          })
        end,
        ["rust_analyzer"] = function()
          require("lspconfig").rust_analyzer.setup({
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
  },
}
