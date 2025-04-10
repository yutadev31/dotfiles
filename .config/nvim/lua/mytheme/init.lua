local M = {}

function M.load()
  local colors = require("mytheme.colors")

  local styles = {
    Normal = { fg = colors.white, bg = "NONE" },
    Keyword = { fg = colors.red },
    Variable = { fg = colors.white },
    Constant = { fg = colors.cyan },
    Function = { fg = colors.blue },
    Module = { fg = colors.yellow },
    Type = { fg = colors.orange },

    String = { fg = colors.green },
    Url = { fg = colors.lime },
    Special = { fg = colors.red },
    Character = { fg = colors.green },
    Boolean = { fg = colors.blue },
    Number = { fg = colors.emerald },
    Float = { fg = colors.emerald },
    EnumMember = { fg = colors.cyan },

    Tag = { fg = colors.red },
    Property = { fg = colors.white },

    Delimiter = { fg = colors.gray },
    Bracket = { fg = colors.gray },

    Comment = { fg = colors.gray },

    Error = { fg = colors.red },
    Warning = { fg = colors.yellow },
    Info = { fg = colors.blue },
    Note = { fg = colors.lime },
    Ok = { fg = colors.emerald },

    Added = { fg = colors.emerald },
    Changed = { fg = colors.blue },
    Removed = { fg = colors.fuchsia },

    Menu = { fg = colors.white, bg = colors.currentline },
    MenuSel = { fg = colors.black, bg = colors.white },
    WinSeparator = { fg = colors.gray },

    Hidden = { fg = colors.gray },
    Directory = { fg = colors.blue },
  }

  local theme = {
    Cursor = { fg = colors.white },
    CursorLine = { bg = colors.currentline },
    Directory = styles.Directory,
    EndOfBuffer = colors.Hidden,
    WinSeparator = styles.WinSeparator,
    LineNr = colors.Hidden,
    CursorLineNr = { fg = colors.white },
    TabLine = { bg = colors.currentline },
    TabLineSel = { fg = colors.black, bg = colors.white },
    Whitespace = colors.Hidden,
    Visual = { bg = colors.currentline },
    Normal = styles.Normal,
    NormalFloat = styles.Normal,
    FloatBorder = styles.WinSeparator,
    Comment = styles.Comment,
    Constant = styles.Constant,
    String = styles.String,
    Character = styles.Character,
    Number = styles.Number,
    Boolean = styles.Boolean,
    Float = styles.Float,
    Identifier = styles.Variable,
    Function = styles.Function,
    Keyword = styles.Keyword,
    PreProc = styles.Keyword,
    Include = { fg = colors.blue },
    Define = styles.Keyword,
    Macro = styles.Keyword,
    PreCondit = styles.Keyword,
    Type = styles.Type,
    StorageClass = styles.Keyword,
    Structure = styles.Keyword,
    Typedef = styles.Keyword,
    Special = styles.Special,
    SpecialChar = styles.Special,
    Tag = styles.Tag,
    Delimiter = styles.Delimiter,
    SpecialComment = styles.Hidden,
    Debug = { fg = colors.yellow },
    Underlined = { fg = colors.green },
    Ignore = { fg = colors.blue },
    Error = styles.Error,
    Todo = styles.Info,
    Added = styles.Added,
    Changed = styles.Character,
    Removed = styles.Removed,
    Pmenu = styles.Menu,
    PmenuSel = styles.MenuSel,
    NotifyBackground = { bg = colors.currentline },

    -- Oil
    OilHidden = styles.Hidden,
    OilDir = styles.Directory,
    OilDirHidden = styles.Hidden,
    OilFile = { fg = colors.white },

    -- Mini Icons
    MiniIconsAzure = { fg = colors.blue },
    MiniIconsBlue = { fg = colors.indigo },
    MiniIconsCyan = { fg = colors.cyan },
    MiniIconsGreen = { fg = colors.green },
    MiniIconsGrey = { fg = colors.white },
    MiniIconsOrange = { fg = colors.orange },
    MiniIconsPurple = { fg = colors.purple },
    MiniIconsRed = { fg = colors.red },
    MiniIconsYellow = { fg = colors.yellow },

    DiagnosticError = styles.Error,
    DiagnosticWarn = styles.Warning,
    DiagnosticInfo = styles.Info,
    DiagnosticHint = styles.Note,
    DiagnosticOk = styles.Ok,

    -- Treesitter
    ["@variable"] = styles.Variable,
    ["@constant"] = styles.Constant,
    ["@module"] = styles.Module,
    ["@string"] = styles.String,
    ["@string.special.url"] = styles.Url,
    ["@character"] = styles.Character,
    ["@boolean"] = styles.Boolean,
    ["@number"] = styles.Number,
    ["@number.float"] = styles.Float,
    ["@type"] = styles.Type,
    ["@property"] = styles.Property,
    ["@function"] = styles.Function,
    ["@function.builtin"] = styles.Function,
    ["@keyword"] = styles.Keyword,
    ["@punctuation.delimiter"] = styles.Delimiter,
    ["@punctuation.bracket"] = styles.Bracket,
    ["@punctuation.special"] = styles.Special,
    ["@comment"] = styles.Comment,
    ["@comment.error"] = styles.Error,
    ["@comment.warning"] = styles.Warning,
    ["@comment.todo"] = styles.Info,
    ["@comment.note"] = styles.Note,
    ["@markup.heading"] = { fg = colors.blue, bold = true },
    ["@markup.link.url"] = styles.Url,
    ["@diff.plus"] = styles.Added,
    ["@diff.minus"] = styles.Removed,
    ["@diff.delta"] = styles.Changed,
    ["@tag"] = styles.Tag,
    ["@tag.attribute"] = styles.Property,

    ["@lsp.type.namespace"] = styles.Module,
    ["@lsp.type.enumMember"] = styles.EnumMember,
  }

  vim.cmd("hi clear")
  for group, value in pairs(theme) do
    vim.api.nvim_set_hl(0, group, value)
  end
end

return M
