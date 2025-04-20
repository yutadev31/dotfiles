local M = {}

M.map = function(mode, lhs, rhs, desc, opt)
  vim.keymap.set(mode, lhs, rhs, opt or { noremap = true, silent = true, desc = desc })
end

for _, mode in pairs({ "n", "v", "i", "s", "o", "c", "t", "x" }) do
  M[mode .. "map"] = function(lhs, rhs, desc, opt)
    M.map(mode, lhs, rhs, desc, opt)
  end
end

M.filetype = function(pattern, callback)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = pattern,
    callback = callback,
  })
end

M.tabsize = function(expandtab, size)
  vim.opt_local.expandtab = expandtab
  vim.opt_local.shiftwidth = size
  vim.opt_local.tabstop = size
  vim.opt_local.softtabstop = size
end

return M
