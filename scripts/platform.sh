#!/bin/sh
set -eu

detect_platform() {
  os=$(uname -s)
  distro=

  if [ "$os" = "Linux" ]; then
    if [ ! -r /etc/os-release ]; then
      echo "Error: unable to detect Linux distribution: /etc/os-release not found." >&2
      return 1
    fi

    . /etc/os-release
    distro=$ID
  fi
}
