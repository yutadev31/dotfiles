local function setup(name, opts)
  require("mini." .. name).setup(opts)
end

return {
  "echasnovski/mini.nvim",
  version = "*",
  config = function()
    setup("icons", {})
    setup("comment", {})
    setup("pairs", {})
    setup("surround", {})
    setup("hipatterns", {})
    setup("starter", {})
    setup("sessions", {})
  end,
}
