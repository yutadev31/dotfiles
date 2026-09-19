local main_mod = "SUPER"

package.path = package.path .. ";./?.lua;./?/init.lua"

hl.monitor({
  output = "HDMI-A-1",
  mode = "preferred",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "0x1080",
  scale = 1,
})

hl.curve("easeOutQuart", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })
hl.curve("easeInOutSine", { type = "bezier", points = { { 0.37, 0 }, { 0.63, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4, bezier = "easeOutQuart" })
hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "easeOutQuart", style = "popin" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "easeOutQuart", style = "popin" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "easeOutQuart", style = "popin" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "easeOutQuart", style = "popin" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "easeOutQuart", style = "slide" })

hl.config({
  general = {
    gaps_in = 8,
    gaps_out = 15,
    border_size = 3,
    col = {
      active_border = "rgb(7aa2f7)",
      inactive_border = "rgb(414868)",
    },
    layout = "dwindle",
  },
  decoration = {
    rounding = 0,
  },
  dwindle = {
    preserve_split = true,
  },
  animations = {
    enabled = true,
  },
  input = {
    kb_layout = "jp",
    kb_options = "ctrl:nocaps,compose:ralt",
    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
      disable_while_typing = true,
    },
  },
  misc = {
    disable_hyprland_logo = true,
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user start hyprland-session.target")
  hl.exec_cmd("waybar")
  hl.exec_cmd("fcitx5 -dr")
end)

hl.bind(main_mod .. " + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind(main_mod .. " + D", hl.dsp.exec_cmd("rofi -show drun -show-icons"))
hl.bind(main_mod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(main_mod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(main_mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(main_mod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(main_mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(main_mod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(main_mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(main_mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(main_mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(main_mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

local smw = require("plugins.split-monitor-workspaces")

smw.setup({
  workspace_count = 5,
})

for i = 1, smw.get_amount_of_workspaces() do
  local n = tostring(i)

  hl.bind(main_mod .. " +" .. n, smw.workspace(n))

  hl.bind(main_mod .. " + SHIFT +" .. n, smw.move_to_workspace_silent(n))
end
