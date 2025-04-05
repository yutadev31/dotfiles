local function setup(name, opts)
  require("mini." .. name).setup(opts)
end

return {
  "echasnovski/mini.nvim",
  version = "*",
  config = function()
    -- Text editing --
    setup("ai", {})
    setup("align", {})
    -- setup("comment", {})
    -- setup("completion", {})
    setup("move", {})
    setup("operators", {})
    setup("pairs", {})
    setup("snippets", {})
    setup("splitjoin", {})
    setup("surround", {})

    -- General workflow --
    setup("basics", {})
    setup("bracketed", {})
    setup("bufremove", {})
    setup("clue", {})
    -- setup("deps", {})
    -- setup("diff", {})
    setup("extra", {})
    -- setup("files", {})
    setup("git", {})
    setup("jump", {})
    setup("jump2d", {})
    setup("misc", {})
    setup("pick", {})
    setup("sessions", {})
    setup("visits", {})

    -- Appearance --
    -- setup("animate", {})
    -- setup("base16", {})
    setup("colors", {})
    setup("cursorword", {})
    setup("hipatterns", {})
    -- setup("hues", {})
    setup("icons", {})
    -- setup("indentscope", {})
    setup("map", {})
    -- setup("notify", {})
    setup("starter", {})
    -- setup("statusline", {})
    setup("tabline", {})
    setup("trailspace", {})

    -- Other --
    setup("doc", {})
    setup("fuzzy", {})
    setup("test", {})
  end,
}
