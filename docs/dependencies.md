# Dependencies for Non-Nix Environments

This page lists the dependencies required to use these dotfiles without `nix/`.

## Prerequisites

This page does not cover automatic installation with a package manager. It lists the packages required to use the configuration. Set `x11=no` or
`wayland=no` in `dotconf.sh` when the corresponding session is not used.

## CLI

These commands are required even when no GUI is used.

| Package | Purpose |
| --- | --- |
| `eza` | Alias for `ls` |
| `fd` | File search for Neovim and other tools |
| `fastfetch` | Displays system information when the shell starts |
| `fish` | Default shell |
| `git` | Git operations and Neovim integration |
| `neovim` | Editor |
| `ripgrep` | Search in Neovim |

## Desktop (Common to X11 and Wayland)

These GUI applications and fonts are used with both X11 and Wayland.

| Package | Purpose |
| --- | --- |
| `alacritty` | Terminal |
| `rofi` | Application launcher |
| `dunst` | Notification daemon |
| `hack-nerd-font` | Fonts and icons for Alacritty, notifications, and the status bar |
| `noto-fonts`, `noto-fonts-cjk` | Standard and CJK fonts |
| `fcitx5` | Input method framework |
| `fcitx5-gtk` | Fcitx5 integration for GTK applications |
| `fcitx5-qt` | Fcitx5 integration for Qt applications |
| `fcitx5-mozc` | Japanese input for Fcitx5 (Mozc) |
| `pavucontrol` | Volume control |

## i3 (X11 Only)

These dependencies are required when using i3 in an X11 session. They are not required if you only use Sway.

| Package | Purpose |
| --- | --- |
| `i3-wm` | Window manager |
| `xorg-server` | X11 server |
| `xorg-xinit` or a display manager | Starts an X11 session |
| `maim` | Screenshots for the i3 configuration |
| `xclip` | Copies screenshots to the X11 clipboard |

## Sway (Wayland Only)

These dependencies are required when using Sway in a Wayland session. They are not required if you only use i3.

| Package | Purpose |
| --- | --- |
| `sway` | Wayland compositor |
| `grim` | Screenshots |
| `slurp` | Selects a screenshot region |
| `wl-clipboard` | Wayland clipboard via `wl-copy` |
| `dbus` | Starts a Sway session via `dbus-run-session` |

`wayvnc` is an optional dependency used only with the Sway configuration for VMs (`vm=yes`).
