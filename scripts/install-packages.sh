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

  x11=${x11:-yes}
  wayland=${wayland:-yes}
  vm=${vm:-no}

  case "$x11" in
  yes | no) ;;
  *)
    echo "Error: x11 must be yes or no in $dotdir/dotconf.sh." >&2
    exit 1
    ;;
  esac

  case "$wayland" in
  yes | no) ;;
  *)
    echo "Error: wayland must be yes or no in $dotdir/dotconf.sh." >&2
    exit 1
    ;;
  esac

  if [ "$x11" = "yes" ] || [ "$wayland" = "yes" ]; then
    gui=yes
  else
    gui=no
  fi

  case "$vm" in
  yes | no) ;;
  *)
    echo "Error: vm must be yes or no in $dotdir/dotconf.sh." >&2
    exit 1
    ;;
  esac
}

not_implemented() {
  os=${1:?not_implemented: missing OS name}
  echo "Error: package installation for $os is not implemented yet." >&2
  exit 1
}

install_arch() {
  pacman_install() {
    pacman -S --noconfirm --needed "$@"
  }

  pacman_install \
    eza \
    fd \
    fastfetch \
    fish \
    git \
    neovim \
    ripgrep

  if [ "$gui" = "yes" ]; then
    pacman_install \
      alacritty \
      dunst \
      fcitx5 \
      fcitx5-gtk \
      fcitx5-mozc \
      fcitx5-qt \
      noto-fonts \
      noto-fonts-cjk \
      pavucontrol \
      rofi \
      ttf-hack-nerd
  fi

  if [ "$x11" = "yes" ]; then
    pacman_install \
      i3-wm \
      maim \
      xclip \
      xorg-server \
      xorg-xinit
  fi

  if [ "$wayland" = "yes" ]; then
    pacman_install \
      dbus \
      grim \
      slurp \
      sway \
      waybar \
      wl-clipboard

    if [ "$vm" = "yes" ]; then
      pacman_install wayvnc
    fi
  fi
}

install_void() {
  xbps_install() {
    xbps-install -S -y "$@"
  }

  xbps_install \
    eza \
    fd \
    fastfetch \
    fish-shell \
    git \
    neovim \
    ripgrep

  if [ "$gui" = "yes" ]; then
    xbps_install \
      alacritty \
      alacritty-terminfo \
      dunst \
      fcitx5 \
      fcitx5-gtk \
      fcitx5-mozc \
      fcitx5-qt \
      font-hack-ttf \
      hicolor-icon-theme \
      noto-fonts-cjk \
      noto-fonts-ttf \
      pavucontrol \
      rofi
  fi

  if [ "$x11" = "yes" ]; then
    xbps_install \
      i3 \
      maim \
      xclip \
      xorg-server \
      xinit
  fi

  if [ "$wayland" = "yes" ]; then
    xbps_install \
      dbus \
      elogind \
      grim \
      mesa-dri \
      slurp \
      sway \
      waybar \
      wl-clipboard

    if [ "$vm" = "yes" ]; then
      xbps_install wayvnc
    fi
  fi
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
