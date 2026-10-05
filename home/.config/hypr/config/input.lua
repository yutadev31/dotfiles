hl.config({
  input = {
    kb_layout = "jp",
    kb_options = "ctrl:nocaps,compose:ralt",
    touchpad = {
      natural_scroll = true,
      tap_to_click = false,
      disable_while_typing = false,
    },
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})
