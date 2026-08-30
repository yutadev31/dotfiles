#!/bin/sh
set -eu

dry_run=no

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run]

Install the managed dotfiles into $HOME. Existing paths are moved to a unique
backup directory under ~/.dotfiles-backup. Use --dry-run to preview changes.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
  --dry-run) dry_run=yes ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "Error: unknown option: $1" >&2
    usage >&2
    exit 2
    ;;
  esac
  shift
done

if [ "$(uname -s)" = "Linux" ] && [ -r /etc/os-release ] && grep -qx 'ID=nixos' /etc/os-release; then
  echo "Error: install.sh cannot be run on NixOS." >&2
  exit 1
fi

dotdir=$(CDPATH= cd "$(dirname "$0")" && pwd)
backup_root="$HOME/.dotfiles-backup"
backup_dir=
moved_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-moved.XXXXXX")
created_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-created.XXXXXX")

rollback() {
  [ "$dry_run" = "yes" ] && return

  while IFS= read -r path; do
    rm -f "$HOME/$path"
  done < "$created_paths"

  while IFS= read -r path; do
    if [ -e "$backup_dir/$path" ] || [ -L "$backup_dir/$path" ]; then
      mkdir -p "$(dirname "$HOME/$path")"
      mv "$backup_dir/$path" "$HOME/$path"
    fi
  done < "$moved_paths"
}

cleanup() {
  status=$?
  if [ "$status" -ne 0 ]; then
    echo "Installation failed; restoring changed paths..." >&2
    rollback
  fi
  rm -f "$moved_paths" "$created_paths"
  exit "$status"
}

trap cleanup EXIT HUP INT TERM

base_paths='.bin
.config/fastfetch
.config/fish
.config/nvim
.config/tmux
.gitmessage
'

gui_paths='.config/alacritty
.config/chrome-flags.conf
.config/fcitx5
.config/mako
.config/rofi
.config/sway
.config/waybar
.local/share/rofi/themes
.local/share/wallpapers
'

load_configuration() {
  if [ ! -f "$dotdir/dotconf.sh" ]; then
    echo "Error: create $dotdir/dotconf.sh before running the installer." >&2
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

  vm=${vm:-no}
  case "$vm" in
  yes | no) ;;
  *)
    echo "Error: vm must be yes or no in $dotdir/dotconf.sh." >&2
    exit 1
    ;;
  esac
}

managed_paths() {
  printf '%s\n' "$base_paths"

  if [ "$gui" = "yes" ]; then
    printf '%s\n' "$gui_paths"
  fi
}

is_managed_link() {
  path=${1:?is_managed_link: missing path}

  [ -L "$HOME/$path" ] && [ "$(readlink "$HOME/$path")" = "$dotdir/home/$path" ]
}

preflight() {
  load_configuration

  while IFS= read -r path; do
    if [ ! -e "$dotdir/home/$path" ]; then
      echo "Error: managed source does not exist: $dotdir/home/$path" >&2
      exit 1
    fi

    if is_managed_link "$path"; then continue; fi
  done <<EOF
$(managed_paths)
EOF
}

ensure_backup_dir() {
  if [ -n "$backup_dir" ]; then return; fi

  mkdir -p "$backup_root"
  backup_dir=$(mktemp -d "$backup_root/install.XXXXXXXX")
}

install_file() {
  path=${1:?install_file: missing path}

  # Leave links created by this installer untouched.
  if is_managed_link "$path"; then return; fi

  if [ "$dry_run" = "yes" ]; then
    if [ -e "$HOME/$path" ] || [ -L "$HOME/$path" ]; then
      echo "Would move ~/$path to a new backup directory"
    fi
    echo "Would create ~/$path"
    return
  fi

  # Move an existing file, directory, or incorrect symbolic link aside.
  if [ -e "$HOME/$path" ] || [ -L "$HOME/$path" ]; then
    ensure_backup_dir
    mkdir -p "$(dirname "$backup_dir/$path")"
    printf '%s\n' "$path" >> "$moved_paths"
    mv "$HOME/$path" "$backup_dir/$path"
    echo "Move ~/$path to $backup_dir/$path"
  fi

  # Create a symbolic link
  mkdir -p "$(dirname "$HOME/$path")"
  ln -s "$dotdir/home/$path" "$HOME/$path"
  printf '%s\n' "$path" >> "$created_paths"
  echo "Create ~/$path"
}

install_files() {
  echo "Installing files..."

  while IFS= read -r path; do
    install_file "$path"
  done <<EOF
$(managed_paths)
EOF
}

gen_files() {
  if [ "$gui" = "no" ]; then return; fi

  if [ "$vm" = "yes" ]; then
    source="$dotdir/home/.config/sway/config-vm"
  else
    source="$dotdir/home/.config/sway/config-rm"
  fi

  if [ "$dry_run" = "yes" ]; then
    echo "Would generate ~/.config/sway/config-gen from $(basename "$source")"
    return
  fi

  generated="$dotdir/home/.config/sway/config-gen"
  temporary=$(mktemp "$dotdir/home/.config/sway/config-gen.XXXXXXXX")
  cp "$source" "$temporary"
  mv "$temporary" "$generated"
  echo "Generate ~/.config/sway/config-gen"
}

finish() {
  if [ -n "$backup_dir" ]; then
    echo "Backups are available in $backup_dir"
  fi
}

install() {
  echo "Installing dotfiles..."

  preflight
  gen_files
  install_files
  finish

  echo "Installed dotfiles successfully."
}

install
