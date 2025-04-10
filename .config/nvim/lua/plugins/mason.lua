return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      automatic_installation = true,
    })

    local on_attach = function(client, bufnr)
      vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true,
        convert = function(item)
          return { abbr = item.label:gsub("%b()", "") }
        end,
      })
    end

    require("mason-lspconfig").setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          on_attach = on_attach,
        })
      end,
      ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup({
          on_attach = on_attach,
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
          on_attach = on_attach,
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
