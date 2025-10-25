#!/bin/bash
set -euo pipefail

# Config filename
CONFIG_FILE="config.txt"

# Install a single dotfile
install_file() {
  path=$1
  dotdir=$(pwd)

  # Check if a symbolic link exists
  if [ -L "$HOME/$path" ]; then return; fi

  # Move to directory if it exists
  if [ -e "$HOME/$path" ]; then
    mv $HOME/$path $HOME/$path.old
    echo "Move ~/$path"
  fi

  # Create a symbolic link
  mkdir -p $(dirname $HOME/$path)
  ln -sf $dotdir/home/$path $HOME/$path
}

# Install all relevant dotfiles
install_files() {
  echo "Installing files..."

  install_file .bin
  install_file .config/cspell
  install_file .config/fastfetch
  install_file .config/fish
  install_file .config/nvim
  install_file .config/tmux
  install_file .gitmessage

  if [[ $SETUP_DESKTOP == 1 ]]; then
    install_file .config/alacritty
  fi

  if [[ $DESKTOP_ENVIRONMENT == "hyprland" ]]; then
    install_file .config/hypr
    install_file .config/mako
    install_file .config/rofi
    install_file .config/waybar
  fi
}

setup_git() {
  git config --global user.name Yuta
  git config --global user.email yuta256dev@gmail.com
  git config --global commit.template ~/.gitmessage
  git config --global init.defaultBranch main
  git config --global ghq.root '~/dev'
}

setup_xdg() {
  xdg-settings set default-web-browser firefox.desktop
}

# Main installation logic
install() {
  local mode="$1"
  echo "Installing dotfiles in '$mode' mode..."
  echo "$mode" >$CONFIG_FILE

  case "$mode" in
  cli)
    export SETUP_DESKTOP=0
    export DESKTOP_ENVIRONMENT=""
    ;;
  hyprland)
    export SETUP_DESKTOP=1
    export DESKTOP_ENVIRONMENT="hyprland"
    ;;
  esac

  install_files
  setup_git

  if [[ $SETUP_DESKTOP == 1 ]]; then
    setup_xdg
  fi

  echo "Installed dotfiles successfully."
}

if [ -z "${1:-}" ]; then
  if [ -e $CONFIG_FILE ]; then
    install $(cat $CONFIG_FILE)
  fi
else
  install "$1"
fi
