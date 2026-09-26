local function setup(name, opts)
  require("mini." .. name).setup(opts)
end

return {
  "echasnovski/mini.nvim",
  version = "*",
  config = function()
    setup("pairs", {})
    setup("icons", { mock_nvim_web_devicons = true })
    setup("cursorword", {})
    setup("indentscope", {})
    setup("trailspace", {})
  end,
}
