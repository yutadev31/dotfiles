return {
  "NeogitOrg/neogit",
  dependencies = { "sindrets/diffview.nvim" },
  opts = {
    disable_hint = false,
    disable_commit_confirmation = true,
    kind = "split",
    integrations = { diffview = true },
    sections = {
      recent = { folded = false },
      untracked = { folded = false },
      unstaged = { folded = false },
      staged = { folded = false },
    },
  },
}
