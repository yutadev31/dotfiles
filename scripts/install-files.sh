#!/bin/sh
set -eu

dry_run=no

usage() {
  cat <<'EOF'
Usage: ./scripts/install-files.sh [--dry-run]

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

if [ "$(uname -s)" = "Linux" ] && [ -r /etc/os-release ] && grep -Eq '^ID="?nixos"?$' /etc/os-release; then
  case "$HOME" in
  /tmp/*) ;;
  *)
    echo "Error: install-files.sh can only run on NixOS when \$HOME is under /tmp." >&2
    exit 1
    ;;
  esac
fi

resolve_script_path() {
  script=$1

  case "$script" in
  /*) ;;
  */*) script=$(CDPATH= cd "$(dirname "$script")" && pwd)/$(basename "$script") ;;
  *)
    script=$(command -v "$script") || {
      echo "Error: cannot locate installer: $1" >&2
      exit 1
    }
    ;;
  esac

  while [ -L "$script" ]; do
    target=$(readlink "$script")
    case "$target" in
    /*) script=$target ;;
    *) script=$(dirname "$script")/$target ;;
    esac
  done

  printf '%s\n' "$script"
}

script_path=$(resolve_script_path "$0")
dotdir=$(CDPATH= cd -P "$(dirname "$script_path")/.." && pwd)
backup_root="$HOME/.dotfiles-backup"
backup_dir=
moved_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-moved.XXXXXX")
created_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-created.XXXXXX")

reverse_paths() {
  awk '{ paths[NR] = $0 } END { for (i = NR; i > 0; i--) print paths[i] }' "$1"
}

rollback() {
  [ "$dry_run" = "yes" ] && return

  reverse_paths "$created_paths" | while IFS= read -r path; do
    rm -f "$HOME/$path"
  done

  reverse_paths "$moved_paths" | while IFS= read -r path; do
    if [ -e "$backup_dir/$path" ] || [ -L "$backup_dir/$path" ]; then
      mkdir -p "$(dirname "$HOME/$path")"
      mv "$backup_dir/$path" "$HOME/$path"
    fi
  done
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
  awk -v gui="$gui" '
    /^[[:space:]]*($|#)/ { next }
    NF != 2 {
      printf "Error: invalid dotlist entry on line %d: expected scope and path\n", NR > "/dev/stderr"
      invalid = 1
      next
    }
    $1 == "base" { print $2; next }
    $1 == "gui" {
      if (gui == "yes") print $2
      next
    }
    {
      printf "Error: invalid dotlist scope on line %d: %s\n", NR, $1 > "/dev/stderr"
      invalid = 1
    }
    END { exit invalid }
  ' "$dotdir/dotlist.txt"
}

is_managed_link() {
  path=${1:?is_managed_link: missing path}

  [ -L "$HOME/$path" ] || return 1

  target=$(readlink "$HOME/$path")
  case "$target" in
  /*) ;;
  *) target=$(dirname "$HOME/$path")/$target ;;
  esac

  target_dir=$(CDPATH= cd -P "$(dirname "$target")" 2>/dev/null && pwd) || return 1
  source_dir=$(CDPATH= cd -P "$(dirname "$dotdir/home/$path")" && pwd)
  [ "$target_dir/$(basename "$target")" = "$source_dir/$(basename "$path")" ]
}

preflight() {
  load_configuration

  if [ ! -f "$dotdir/dotlist.txt" ]; then
    echo "Error: dotfile list does not exist: $dotdir/dotlist.txt" >&2
    exit 1
  fi

  managed_list=$(managed_paths) || exit 1
  while IFS= read -r path; do
    if [ ! -e "$dotdir/home/$path" ]; then
      echo "Error: managed source does not exist: $dotdir/home/$path" >&2
      exit 1
    fi

    for other_path in $managed_list; do
      [ "$path" = "$other_path" ] && continue
      case "$path" in
      "$other_path"/*)
        echo "Error: managed paths must not overlap: $other_path and $path" >&2
        exit 1
        ;;
      esac
    done

    if is_managed_link "$path"; then continue; fi
  done <<EOF
$managed_list
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

  path=.local/share/dotfiles/sway/config-gen

  if [ "$dry_run" = "yes" ]; then
    if [ -e "$HOME/$path" ] || [ -L "$HOME/$path" ]; then
      echo "Would move ~/$path to a new backup directory"
    fi
    echo "Would generate ~/$path from $(basename "$source")"
    return
  fi

  if [ -e "$HOME/$path" ] || [ -L "$HOME/$path" ]; then
    ensure_backup_dir
    mkdir -p "$(dirname "$backup_dir/$path")"
    printf '%s\n' "$path" >> "$moved_paths"
    mv "$HOME/$path" "$backup_dir/$path"
    echo "Move ~/$path to $backup_dir/$path"
  fi

  mkdir -p "$(dirname "$HOME/$path")"
  temporary=$(mktemp "$HOME/$path.XXXXXXXX")
  cp "$source" "$temporary"
  mv "$temporary" "$HOME/$path"
  printf '%s\n' "$path" >> "$created_paths"
  echo "Generate ~/$path"
}

finish() {
  if [ -n "$backup_dir" ]; then
    echo "Backups are available in $backup_dir"
  fi
}

install() {
  echo "Installing dotfiles..."

  preflight
  install_files
  gen_files
  finish

  echo "Installed dotfiles successfully."
}

install
