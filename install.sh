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

install_packages_for_ubuntu() {
  exit 1 # TODO
}

install_packages_for_arch() {
  sudo paru -S --noconfirm --needed $(cat packages/arch-cli.txt)

  if [ $1 = "desktop" ]; then
    sudo paru -S --noconfirm --needed $(cat packages/arch-desktop.txt)
  fi
}

# Install packages from text files
install_packages() {
  echo "Installing packages..."

  if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
    ubuntu)
      install_packages_for_ubuntu $1
      ;;
    arch)
      install_packages_for_arch $1
      ;;
    *)
      echo "Error: Your Linux distribution '$NAME' is not supported by this installer." >&2
      exit 1
      ;;
    esac
  else
    echo "Error: Unable to determine your Linux distribution. '/etc/os-release' file not found." >&2
    exit 1
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

  install_files "$mode"
  install_packages "$mode"
  setup_git

  if [ $1 = "desktop" ]; then
    setup_xdg
  fi

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
