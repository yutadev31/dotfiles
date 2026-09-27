#!/bin/sh
set -eu

dotdir=$(CDPATH= cd -P "$(dirname "$0")" && pwd)

install_packages=false
while getopts "p" option; do
  case "$option" in
  p) install_packages=true ;;
  \?)
    echo "Usage: $0 [-p]" >&2
    exit 2
    ;;
  esac
done

if $install_packages; then
  "$dotdir/scripts/install-packages.sh"
fi

"$dotdir/scripts/install-files.sh"
