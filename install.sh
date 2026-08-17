#!/bin/sh
set -eu

if [ "$(uname -s)" = "Linux" ] && [ -r /etc/os-release ] && grep -qx 'ID=nixos' /etc/os-release; then
  echo "Error: install.sh cannot be run on NixOS." >&2
  exit 1
fi

dotdir=$(CDPATH= cd "$(dirname "$0")" && pwd)

managed_paths='.bin
.config/alacritty
.config/chrome-flags.conf
.config/fastfetch
.config/fcitx5
.config/fish
.config/mako
.config/nvim
.config/rofi
.config/sway
.config/tmux
.config/waybar
.local/share/rofi/themes
.local/share/wallpapers
.gitmessage
'

is_managed_link() {
  path=${1:?is_managed_link: missing path}

  [ -L "$HOME/$path" ] && [ "$(readlink "$HOME/$path")" = "$dotdir/home/$path" ]
}

preflight() {
  if [ ! -f "$dotdir/dotconf.sh" ]; then
    echo "Error: create $dotdir/dotconf.sh before running the installer." >&2
    exit 1
  fi

  for path in $managed_paths; do
    if is_managed_link "$path"; then continue; fi

    if { [ -e "$HOME/$path" ] || [ -L "$HOME/$path" ]; } && { [ -e "$HOME/$path.old" ] || [ -L "$HOME/$path.old" ]; }; then
      echo "Error: refusing to overwrite existing backup ~/$path.old." >&2
      exit 1
    fi
  done
}

install_file() {
  path=${1:?install_file: missing path}

  # Leave links created by this installer untouched.
  if is_managed_link "$path"; then return; fi

  # Move an existing file, directory, or incorrect symbolic link aside.
  if [ -e "$HOME/$path" ] || [ -L "$HOME/$path" ]; then
    mv "$HOME/$path" "$HOME/$path.old"
    echo "Move ~/$path"
  fi

  # Create a symbolic link
  mkdir -p "$(dirname "$HOME/$path")"
  ln -s "$dotdir/home/$path" "$HOME/$path"
  echo "Create ~/$path"
}

install_files() {
  echo "Installing files..."

  for path in $managed_paths; do
    install_file "$path"
  done
}

gen_files() {
  . "$dotdir/dotconf.sh"

  if [ "${vm:-no}" = "yes" ]; then
    cp "$dotdir/home/.config/sway/config-vm" "$dotdir/home/.config/sway/config-gen"
  else
    cp "$dotdir/home/.config/sway/config-rm" "$dotdir/home/.config/sway/config-gen"
  fi
}

install() {
  echo "Installing dotfiles..."

  preflight
  gen_files
  install_files

  echo "Installed dotfiles successfully."
}

install
