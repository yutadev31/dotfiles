-- ui/init.lua
local sidebar = require("yutadev31.ui.core.sidebar")

local M = {}
local views = {}

function M.register_view(view)
  views[view.name] = view
  vim.api.nvim_create_user_command(view.name, function()
    M.open_view(view.name)
  end, {})
end

function M.open_view(name)
  local view = views[name]
  if not view then
    vim.notify("Unknown view: " .. name, vim.log.levels.ERROR)
    return
  end
  sidebar.open(view)
end

function M.setup()
  M.register_view(require("yutadev31.ui.views.files"))
end

return M
