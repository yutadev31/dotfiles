#!/bin/sh
set -eu

dotdir=$(CDPATH= cd -P "$(dirname "$0")" && pwd)

confirm() {
  description=${1:?confirm: missing description}

  printf 'Run %s? [y/N] ' "$description"
  if ! IFS= read -r answer; then
    return 1
  fi

  case "$answer" in
  y | Y | yes | YES) return 0 ;;
  *) return 1 ;;
  esac
}

run_installer() {
  script=${1:?run_installer: missing script}
  description=${2:?run_installer: missing description}

  if confirm "$description"; then
    "$dotdir/$script"
  else
    echo "Skipped $description."
  fi
}

run_installer "scripts/install-packages.sh" "package installation"
run_installer "scripts/install-files.sh" "dotfile installation"
