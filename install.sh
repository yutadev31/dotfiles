#!/bin/sh
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

  if [ $1 = "desktop" ]; then
    install_file .config/alacritty
    install_file .config/hypr
    install_file .config/mako
    install_file .config/rofi
    install_file .config/waybar
  fi
}

# Install packages from text files
install_packages() {
  echo "Installing packages..."

  sudo pacman -S --noconfirm --needed $(cat packages/cli.txt)

  if [ $1 = "desktop" ]; then
    sudo pacman -S --noconfirm --needed $(cat packages/desktop.txt)
  fi
}

# Main installation logic
install() {
  local mode="$1"
  echo "Installing dotfiles in '$mode' mode..."
  echo "$mode" >$CONFIG_FILE

  install_files "$mode"
  install_packages "$mode"

  echo "Installed dotfiles successfully."
}

# Display help
show_help() {
  cat <<EOF
Usage: ./install [OPTIONS]

Options:
  -c    Install CLI tools only
  -d    Install desktop environment (includes CLI tools)
  -h    Show this help message and exit

Notes:
  - Once you choose an option, it will be remembered.
  - The next time you run this script, the previously chosen option
    will be used as the default.
EOF
  exit 0
}

# Parse options
while getopts "cdh" opt; do
  case "$opt" in
  c)
    install cli
    exit 0
    ;;
  d)
    install desktop
    exit 0
    ;;
  h) show_help ;;
  ?) exit 1 ;;
  esac
done

# If no options given, use saved config
if [ -e $CONFIG_FILE ]; then
  install $(cat $CONFIG_FILE)
else
  show_help
  exit 1
fi
