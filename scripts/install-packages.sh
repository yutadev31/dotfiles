#!/bin/sh
set -eu

dotdir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)

load_configuration() {
  if [ ! -f "$dotdir/dotconf.sh" ]; then
    echo "Error: create $dotdir/dotconf.sh before running the package installer." >&2
    exit 1
  fi

  . "$dotdir/dotconf.sh"

  gui=${gui:-yes}

  case "$gui" in
  yes | no) ;;
  *)
    echo "Error: gui must be yes or no in $dotdir/dotconf.sh." >&2
    exit 1
    ;;
  esac
}

install_arch() {
  pacman -S --noconfirm --needed \
    eza \
    fish \
    git \
    neovim

  if [ "$gui" = "yes" ]; then
    pacman -S --noconfirm --needed \
      alacritty \
      fcitx5 \
      fcitx5-mozc \
      grim \
      mako \
      rofi \
      slurp \
      sway \
      waybar \
      wayvnc
  fi
}

not_implemented() {
  os=${1:?not_implemented: missing OS name}
  echo "Error: package installation for $os is not implemented yet." >&2
  exit 1
}

install_void() {
  not_implemented "Void Linux"
}

install_freebsd() {
  not_implemented "FreeBSD"
}

install_openbsd() {
  not_implemented "OpenBSD"
}

install_netbsd() {
  not_implemented "NetBSD"
}

install_dragonfly() {
  not_implemented "DragonFly BSD"
}

install_linux() {
  if [ -r /etc/os-release ]; then
    . /etc/os-release
  else
    echo "Unable to detect the Linux distribution: /etc/os-release not found."
    exit 1
  fi

  case "$ID" in
  arch)
    install_arch
    ;;
  void)
    install_void
    ;;
  *)
    echo "Error: $NAME is not supported." >&2
    exit 1
    ;;
  esac
}

install() {
  load_configuration

  os="$(uname -s)"
  case "$os" in
  Linux)
    install_linux
    ;;
  FreeBSD)
    install_freebsd
    ;;
  OpenBSD)
    install_openbsd
    ;;
  NetBSD)
    install_netbsd
    ;;
  DragonFly)
    install_dragonfly
    ;;
  *)
    echo "Error: $os is not supported." >&2
    exit 1
    ;;
  esac
}

install
