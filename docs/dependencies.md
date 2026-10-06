# Dependencies for Non-Nix Environments

This page lists the packages used by the portable shell-based setup. NixOS and
Home Manager users should use the packages declared by the flake instead.

The package names in this page are the Arch Linux names unless noted
otherwise. `scripts/install-packages.sh` currently installs the listed package
sets on Arch Linux and Void Linux. It does not install packages on the BSD
platforms supported by the platform detector.

## Configuration

Create `dotconf.sh` from `dotconf.example.sh` before installing packages. The
current example defaults to `i3=no`, `sway=no`, `hyprland=no`, and `vm=no`.
Only dependencies for enabled window managers are required. `vm=yes` adds
`wayvnc` when Sway is enabled.

## Base CLI

These packages are used by the base shell and editor configuration:

| Package | Purpose |
| --- | --- |
| `eza` | `ls` alias |
| `fd` | File search for Neovim and other tools |
| `fastfetch` | System information at shell startup |
| `fish` | Shell |
| `git` | Version control and Neovim integration |
| `neovim` | Editor |
| `ripgrep` | Search in Neovim |

The portable dotlist also links a tmux configuration, so install `tmux` when
using `home/.config/tmux/tmux.conf`.

## Common desktop dependencies

These packages are installed when at least one graphical option is enabled:

| Package | Purpose |
| --- | --- |
| `alacritty` | Terminal |
| `dunst` | Notification daemon |
| `rofi` | Application launcher |
| [`rubar`](https://github.com/yutadev31/rubar) | Status bar |
| `fcitx5` | Input method framework |
| `fcitx5-gtk` | Fcitx5 integration for GTK applications |
| `fcitx5-mozc` | Japanese input for Fcitx5 (Mozc) |
| `fcitx5-qt` | Fcitx5 integration for Qt applications |
| `noto-fonts`, `noto-fonts-cjk` | Standard and CJK fonts |
| `ttf-hack-nerd` | Font and icon glyphs |
| `pavucontrol` | Volume control |
| [`shot`](https://github.com/yutadev31/shot) | Screenshots |
| [`cpst`](https://github.com/yutadev31/cpst) | Clipboard |

The portable configuration also includes the Rubar and Shot configuration
files; their executables are not installed by the package helper.

## i3 (X11)

Install these when `i3=yes`:

| Package | Purpose |
| --- | --- |
| `i3-wm` | Window manager |
| `xorg-server` | X11 server |
| `xorg-xinit` | Starts an X11 session |

## Sway (Wayland)

Install these when `sway=yes`:

| Package | Purpose |
| --- | --- |
| `sway` | Wayland compositor |

## Hyprland (Wayland)

Install these when `hyprland=yes`:

| Package | Purpose |
| --- | --- |
| `hyprland` | Wayland compositor |
