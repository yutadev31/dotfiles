#!/bin/sh
set -eu

CONFIG_FILE="config.txt"

install_file() {
  path=${1:?install_file: missing path}
  dotdir=$(pwd)

  # Check if a symbolic link exists
  if [ -L "$HOME/$path" ]; then return; fi

  # Move to directory if it exists
  if [ -e "$HOME/$path" ]; then
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

  install_file .bin
  install_file .config/alacritty
  install_file .config/fcitx5
  install_file .config/fish
  install_file .config/mako
  install_file .config/nvim
  install_file .config/rofi
  install_file .config/sway
  install_file .config/waybar
  install_file .gitmessage
}

gen_files() {
  . dotconf.sh

  if [ "${vm:-no}" = "yes" ]; then
    cp "$(pwd)/home/.config/sway/config-vm" "$(pwd)/home/.config/sway/config-env"
  else
    cp "$(pwd)/home/.config/sway/config-rm" "$(pwd)/home/.config/sway/config-env"
  fi
}

install() {
  echo "Installing dotfiles..."

  install_files
  gen_files

  echo "Installed dotfiles successfully."
}

install
