local M = {}

M.map = function(mode, lhs, rhs, opt)
  vim.keymap.set(mode, lhs, rhs, opt or { noremap = true, silent = true })
end

for _, mode in pairs({ "n", "v", "i", "s", "o", "c", "t", "x" }) do
  M[mode .. "map"] = function(lhs, rhs, opt)
    M.map(mode, lhs, rhs, opt)
  end
end

return M
