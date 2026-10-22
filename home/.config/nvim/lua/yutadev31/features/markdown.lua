local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      vim.keymap.set("i", "<CR>", function()
        local line = vim.api.nvim_get_current_line()

        if line:match("^%s*[-*+]%s*$") then
          return "<C-u>"
        end

        local indent, marker = line:match("^(%s*)([-*+]%s+)")
        if marker then
          return "<CR>" .. indent .. marker
        end

        return "<CR>"
      end, {
        buffer = true,
        expr = true,
      })
    end,
  })
end

return M
