#!/bin/bash
set -euo pipefail

CONFIG_FILE="config.txt"

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
  echo "Create ~/$path"
}

install_files() {
  echo "Installing files..."

  install_file .bin
  install_file .config/btop
  install_file .config/cspell
  install_file .config/fastfetch
  install_file .config/fish
  install_file .config/nvim
  install_file .config/tmux
  install_file .gitmessage

  if [[ $SETUP_DESKTOP == 1 ]]; then
    install_file .config/alacritty
    install_file .config/fcitx5
    install_file .config/hypr
    install_file .config/mako
    install_file .config/rofi
    install_file .config/sway
    install_file .config/waybar
    install_file .config/chrome-flags.conf
  fi
}

setup_git() {
  git config --global user.name Yuta
  git config --global user.email yuta256dev@gmail.com
  git config --global commit.template ~/.gitmessage
  git config --global init.defaultBranch main
  git config --global ghq.root '~/dev'
}

install() {
  local mode="$1"
  echo "Installing dotfiles in '$mode' mode..."
  echo "$mode" >$CONFIG_FILE

  case "$mode" in
  cli)
    export SETUP_DESKTOP=0
    ;;
  desktop)
    export SETUP_DESKTOP=1
    ;;
  esac

  install_files
  setup_git

  echo "Installed dotfiles successfully."
}

if [ -z "${1:-}" ]; then
  if [ -e $CONFIG_FILE ]; then
    install $(cat $CONFIG_FILE)
  fi
else
  install "$1"
fi
