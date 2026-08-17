#!/bin/sh
set -eu

install_arch() {
  pacman -S --noconfirm --needed \
    fish neovim
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
      install_arch ;;
    void)
      install_void ;;
    *)
      echo "$NAME is not supported."
      exit 1 ;;
  esac
}

install() {
  os="$(uname -s)"
  case "$os" in
    Linux)
      install_linux ;;
    FreeBSD)
      install_freebsd ;;
    OpenBSD)
      install_openbsd ;;
    NetBSD)
      install_netbsd ;;
    DragonFly)
      install_dragonfly ;;
    *)
      echo "$os is not supported."
      exit 1 ;;
  esac
}

install
