#!/bin/sh
set -eu

dotdir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
. "$dotdir/scripts/platform.sh"

load_configuration() {
  if [ ! -f "$dotdir/dotconf.sh" ]; then
    echo "Error: create $dotdir/dotconf.sh before running the package installer." >&2
    exit 1
  fi

  . "$dotdir/dotconf.sh"

  gui=${gui:-yes}
  vm=${vm:-no}

  case "$gui" in
  yes | no) ;;
  *)
    echo "Error: gui must be yes or no in $dotdir/dotconf.sh." >&2
    exit 1
    ;;
  esac

  case "$vm" in
  yes | no) ;;
  *)
    echo "Error: vm must be yes or no in $dotdir/dotconf.sh." >&2
    exit 1
    ;;
  esac
}

install_arch() {
  pacman -S --noconfirm --needed \
    eza \
    fd \
    fastfetch \
    fish \
    git \
    neovim \
    ripgrep

  if [ "$gui" = "yes" ]; then
    pacman -S --noconfirm --needed \
      alacritty \
      dunst \
      fcitx5 \
      fcitx5-gtk \
      fcitx5-mozc \
      fcitx5-qt \
      i3-wm \
      maim \
      noto-fonts \
      noto-fonts-cjk \
      pavucontrol \
      rofi \
      ttf-hack-nerd \
      xclip \
      xorg-server \
      xorg-xinit \
      grim \
      slurp \
      sway \
      waybar \
      wl-clipboard \
      dbus

    if [ "$vm" = "yes" ]; then
      pacman -S --noconfirm --needed wayvnc
    fi
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
  case "$distro" in
  arch)
    install_arch
    ;;
  void)
    install_void
    ;;
  *)
    echo "Error: $distro is not supported." >&2
    exit 1
    ;;
  esac
}

install() {
  load_configuration
  detect_platform

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
