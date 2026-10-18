#!/bin/sh
set -eu

dotdir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
. "$dotdir/scripts/platform.sh"

load_configuration() {
  if [ ! -f "$dotdir/dotconf.sh" ]; then
    echo "Error: $dotdir/dotconf.sh is missing. Create it before running the package installer:" >&2
    echo "cp dotconf.example.sh dotconf.sh" >&2
    exit 1
  fi

  set -a
  . "$dotdir/dotconf.sh"
  set +a
  i3=${i3:-auto}
  sway=${sway:-auto}
  hyprland=${hyprland:-auto}
  niri=${niri:-no}
  vm=${vm:-no}
  export i3 sway hyprland niri vm

  case "$vm" in
  yes | no) ;;
  *)
    echo "Error: vm must be yes or no in $dotdir/dotconf.sh." >&2
    exit 1
    ;;
  esac

  options=$(CDPATH= cd -P "$dotdir" && ./dotscopes.sh) || exit 1
  while IFS='=' read -r scope value; do
    case "$scope" in
    i3) i3=$value ;;
    sway) sway=$value ;;
    hyprland) hyprland=$value ;;
    niri) niri=$value ;;
    gui) gui=$value ;;
    esac
  done <<EOF
$options
EOF
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

  if [ "$i3" = "yes" ]; then
    pacman_install \
      i3-wm \
      maim \
      xclip \
      xorg-server \
      xorg-xinit
  fi

  if [ "$sway" = "yes" ]; then
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

  if [ "$hyprland" = "yes" ]; then
    pacman_install \
      dbus \
      grim \
      hyprland \
      slurp \
      waybar \
      wl-clipboard
  fi

  if [ "$niri" = "yes" ]; then
    pacman_install \
      dbus \
      grim \
      niri \
      slurp \
      wl-clipboard
  fi
}

install_void() {
  xbps_install() {
    xbps-install -S -y "$@"
  }

  xbps_install \
    alacritty-terminfo \
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
      dunst \
      fcitx5 \
      fcitx5-gtk \
      fcitx5-mozc \
      fcitx5-qt \
      hicolor-icon-theme \
      noto-fonts-cjk \
      noto-fonts-ttf \
      pavucontrol \
      rofi

    # TODO Add Hack Nerd Font
  fi

  if [ "$i3" = "yes" ]; then
    xbps_install \
      i3 \
      maim \
      xclip \
      xorg-server \
      xinit
  fi

  if [ "$sway" = "yes" ]; then
    xbps_install \
      dbus \
      elogind \
      grim \
      mesa-dri \
      slurp \
      sway \
      wl-clipboard

    if [ "$vm" = "yes" ]; then
      xbps_install wayvnc
    fi
  fi

  if [ "$hyprland" = "yes" ]; then
    xbps_install \
      dbus \
      elogind \
      grim \
      hyprland \
      mesa-dri \
      slurp \
      waybar \
      wl-clipboard
  fi

  if [ "$niri" = "yes" ]; then
    xbps_install \
      dbus \
      elogind \
      grim \
      mesa-dri \
      niri \
      slurp \
      wl-clipboard
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
