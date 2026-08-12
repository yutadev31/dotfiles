local function setup(name, opts)
  require("mini." .. name).setup(opts)
end

return {
  "echasnovski/mini.nvim",
  version = "*",
  config = function()
    setup("pairs", {})
    setup("icons", { mock_nvim_web_devicons = true })
    setup("surround", {})
    setup("cursorword", {})
    setup("indentscope", {})
    setup("trailspace", {})
    setup("notify", {})
    vim.notify = require("mini.notify").make_notify()
  end,
}
