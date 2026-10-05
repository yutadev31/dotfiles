#!/bin/sh
set -eu

dry_run=no

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run]

Install the managed dotfiles into $HOME and /etc. Existing paths are moved to
unique backup directories. Use --dry-run to preview changes.
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

dotdir=$(CDPATH= cd -P "$(dirname "$0")" && pwd)
. "$dotdir/scripts/platform.sh"
detect_platform

if [ "$os" = "Linux" ] && [ "$distro" = "nixos" ]; then
  case "$HOME" in
  /tmp/*) ;;
  *)
    echo 'Error: install.sh can only run on NixOS when $HOME is under /tmp.' >&2
    exit 1
    ;;
  esac
fi

backup_root="$HOME/.dotfiles-backup"
backup_dir=
etc_backup_root=/etc/.dotfiles-backup
etc_backup_dir=
moved_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-moved.XXXXXX")
created_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-created.XXXXXX")
etc_moved_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-etc-moved.XXXXXX")
etc_created_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-etc-created.XXXXXX")

path_exists() {
  _path_exists_target=${1:?path_exists: missing path}
  [ -e "$_path_exists_target" ] || [ -L "$_path_exists_target" ]
}

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

  reverse_paths "$etc_created_paths" | while IFS= read -r path; do
    root_cmd rm -f "/etc/$path"
  done

  reverse_paths "$etc_moved_paths" | while IFS= read -r path; do
    if root_cmd test -e "$etc_backup_dir/$path" || root_cmd test -L "$etc_backup_dir/$path"; then
      root_cmd mkdir -p "$(dirname "/etc/$path")"
      root_cmd mv "$etc_backup_dir/$path" "/etc/$path"
    fi
  done
}

cleanup() {
  status=$?
  if [ "$status" -ne 0 ]; then
    echo "Installation failed; restoring changed paths..." >&2
    rollback
  fi
  rm -f "$moved_paths" "$created_paths" "$etc_moved_paths" "$etc_created_paths"
  exit "$status"
}

trap cleanup EXIT HUP INT TERM

load_configuration() {
  if [ ! -f "$dotdir/dotconf.sh" ]; then
    echo "Error: create $dotdir/dotconf.sh before running the installer." >&2
    exit 1
  fi

  . "$dotdir/dotconf.sh"

  i3=${i3:-yes}
  sway=${sway:-yes}
  hyprland=${hyprland:-no}

  validate_option i3 "$i3"
  validate_option sway "$sway"
  validate_option hyprland "$hyprland"

  # Keep platform scopes available in dotlists for all supported window managers.
  x11=$i3
  wayland=$sway
  if [ "$hyprland" = "yes" ]; then
    wayland=yes
  fi

  if [ "$i3" = "yes" ] || [ "$sway" = "yes" ] || [ "$hyprland" = "yes" ]; then
    gui=yes
  else
    gui=no
  fi

  vm=${vm:-no}
  validate_option vm "$vm"

  export gui i3 sway hyprland x11 wayland vm
}

validate_option() {
  name=${1:?validate_option: missing name}
  value=${2:?validate_option: missing value}

  case "$value" in
  yes | no) ;;
  *)
    echo "Error: $name must be yes or no in $dotdir/dotconf.sh." >&2
    exit 1
    ;;
  esac
}

managed_paths() {
  list=${1:?managed_paths: missing list}
  awk -v gui="$gui" -v i3="$i3" -v sway="$sway" -v hyprland="$hyprland" -v x11="$x11" -v wayland="$wayland" '
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
    $1 == "i3" {
      if (i3 == "yes") print $2
      next
    }
    $1 == "sway" {
      if (sway == "yes") print $2
      next
    }
    $1 == "hyprland" {
      if (hyprland == "yes") print $2
      next
    }
    $1 == "x11" {
      if (x11 == "yes") print $2
      next
    }
    $1 == "wayland" {
      if (wayland == "yes") print $2
      next
    }
    {
      printf "Error: invalid dotlist scope on line %d: %s\n", NR, $1 > "/dev/stderr"
      invalid = 1
    }
    END { exit invalid }
  ' "$dotdir/$list"
}

root_cmd() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

is_managed_link() {
  path=${1:?is_managed_link: missing path}
  source=${2:-}

  [ -L "$HOME/$path" ] || return 1

  if [ -z "$source" ]; then
    resolve_source "$dotdir/home/$path"
    source=$resolved_source
  fi

  target=$(readlink "$HOME/$path")
  case "$target" in
  /*) ;;
  *) target=$(dirname "$HOME/$path")/$target ;;
  esac

  target_dir=$(CDPATH= cd -P "$(dirname "$target")" 2>/dev/null && pwd) || return 1
  source_dir=$(CDPATH= cd -P "$(dirname "$source")" && pwd)
  [ "$target_dir/$(basename "$target")" = "$source_dir/$(basename "$source")" ]
}

is_managed_etc_link() {
  path=${1:?is_managed_etc_link: missing path}
  source=${2:-}

  [ -L "/etc/$path" ] || return 1

  if [ -z "$source" ]; then
    resolve_source "$dotdir/etc/$path"
    source=$resolved_source
  fi

  target=$(readlink "/etc/$path")
  case "$target" in
  /*) ;;
  *) target=$(dirname "/etc/$path")/$target ;;
  esac

  target_dir=$(CDPATH= cd -P "$(dirname "$target")" 2>/dev/null && pwd) || return 1
  source_dir=$(CDPATH= cd -P "$(dirname "$source")" && pwd)
  [ "$target_dir/$(basename "$target")" = "$source_dir/$(basename "$source")" ]
}

resolve_source() {
  source=${1:?resolve_source: missing source}
  resolved_source=$source

  if [ ! -f "$source/dotmeta" ]; then
    return
  fi

  if [ ! -x "$source/dotmeta" ]; then
    echo "Error: dotmeta is not executable: $source/dotmeta" >&2
    return 1
  fi

  selected=$(CDPATH= cd -P "$source" && ./dotmeta) || {
    echo "Error: failed to execute: $source/dotmeta" >&2
    return 1
  }

  newline='
'
  case "$selected" in
  "" | */* | *"$newline"*)
    echo "Error: dotmeta must print one file name: $source/dotmeta" >&2
    return 1
    ;;
  esac

  resolved_source=$source/$selected
  if [ ! -f "$resolved_source" ]; then
    echo "Error: dotmeta selected a missing file: $resolved_source" >&2
    return 1
  fi
}

preflight() {
  load_configuration

  if [ ! -f "$dotdir/dotlist.home.txt" ]; then
    echo "Error: dotfile list does not exist: $dotdir/dotlist.home.txt" >&2
    exit 1
  fi

  managed_list=$(managed_paths dotlist.home.txt) || exit 1
  while IFS= read -r path; do
    [ -n "$path" ] || continue
    if [ ! -e "$dotdir/home/$path" ]; then
      echo "Error: managed source does not exist: $dotdir/home/$path" >&2
      exit 1
    fi
    resolve_source "$dotdir/home/$path" || exit 1

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

  if [ ! -f "$dotdir/dotlist.etc.txt" ]; then
    echo "Error: dotfile list does not exist: $dotdir/dotlist.etc.txt" >&2
    exit 1
  fi

  etc_managed_list=$(managed_paths dotlist.etc.txt) || exit 1
  if [ -n "$etc_managed_list" ] && [ "$dry_run" = no ] && [ "$(id -u)" -ne 0 ]; then
    command -v sudo >/dev/null 2>&1 || {
      echo 'Error: sudo is required to install files under /etc.' >&2
      exit 1
    }
    sudo -v
  fi

  while IFS= read -r path; do
    [ -n "$path" ] || continue
    if [ ! -e "$dotdir/etc/$path" ]; then
      echo "Error: managed source does not exist: $dotdir/etc/$path" >&2
      exit 1
    fi
    resolve_source "$dotdir/etc/$path" || exit 1

    for other_path in $etc_managed_list; do
      [ "$path" = "$other_path" ] && continue
      case "$path" in
      "$other_path"/*)
        echo "Error: managed paths must not overlap: $other_path and $path" >&2
        exit 1
        ;;
      esac
    done

    if is_managed_etc_link "$path"; then continue; fi
  done <<EOF
$etc_managed_list
EOF
}

ensure_backup_dir() {
  if [ -n "$backup_dir" ]; then return; fi

  mkdir -p "$backup_root"
  backup_dir=$(mktemp -d "$backup_root/install.XXXXXXXX")
}

backup_path() {
  _backup_path_name=${1:?backup_path: missing path}
  _backup_path_target=${2:?backup_path: missing target}

  ensure_backup_dir
  mkdir -p "$(dirname "$backup_dir/$_backup_path_name")"
  printf '%s\n' "$_backup_path_name" >>"$moved_paths"
  mv "$_backup_path_target" "$backup_dir/$_backup_path_name"
  echo "Move ~/$_backup_path_name to $backup_dir/$_backup_path_name"
}

create_link() {
  _create_link_path=${1:?create_link: missing path}
  _create_link_target=${2:?create_link: missing target}

  mkdir -p "$(dirname "$_create_link_path")"
  ln -s "$_create_link_target" "$_create_link_path"
  printf '%s\n' "${_create_link_path#"$HOME/"}" >>"$created_paths"
}

install_file() {
  path=${1:?install_file: missing path}
  resolve_source "$dotdir/home/$path"
  source=$resolved_source

  # Leave links created by this installer untouched.
  if is_managed_link "$path" "$source"; then return; fi

  if [ "$dry_run" = "yes" ]; then
    if [ -e "$HOME/$path" ] || [ -L "$HOME/$path" ]; then
      echo "Would move ~/$path to a new backup directory"
    fi
    echo "Would create ~/$path"
    return
  fi

  # Move an existing file, directory, or incorrect symbolic link aside.
  if path_exists "$HOME/$path"; then
    backup_path "$path" "$HOME/$path"
  fi

  # Create a symbolic link
  create_link "$HOME/$path" "$source"
  echo "Create ~/$path"
}

ensure_etc_backup_dir() {
  if [ -n "$etc_backup_dir" ]; then return; fi

  root_cmd mkdir -p "$etc_backup_root"
  etc_backup_dir=$(root_cmd mktemp -d "$etc_backup_root/install.XXXXXXXX")
}

install_etc_file() {
  path=${1:?install_etc_file: missing path}
  resolve_source "$dotdir/etc/$path"
  source=$resolved_source

  if is_managed_etc_link "$path" "$source"; then return; fi

  if [ "$dry_run" = "yes" ]; then
    if [ -e "/etc/$path" ] || [ -L "/etc/$path" ]; then
      echo "Would move /etc/$path to a new backup directory"
    fi
    echo "Would create /etc/$path"
    return
  fi

  if path_exists "/etc/$path"; then
    ensure_etc_backup_dir
    root_cmd mkdir -p "$(dirname "$etc_backup_dir/$path")"
    printf '%s\n' "$path" >>"$etc_moved_paths"
    root_cmd mv "/etc/$path" "$etc_backup_dir/$path"
    echo "Move /etc/$path to $etc_backup_dir/$path"
  fi

  root_cmd mkdir -p "$(dirname "/etc/$path")"
  root_cmd ln -s "$source" "/etc/$path"
  printf '%s\n' "$path" >>"$etc_created_paths"
  echo "Create /etc/$path"
}

install_files() {
  echo "Installing files..."

  while IFS= read -r path; do
    install_file "$path"
  done <<EOF
$(managed_paths dotlist.home.txt)
EOF
}

install_etc_files() {
  echo "Installing /etc files..."

  while IFS= read -r path; do
    [ -n "$path" ] || continue
    install_etc_file "$path"
  done <<EOF
$(managed_paths dotlist.etc.txt)
EOF
}

gen_files() {
  if [ "$sway" = "no" ]; then return; fi

  path=.local/share/dotfiles/sway/config-gen
  source_dir="$dotdir/home/.config/sway/config-gen"
  target="$HOME/$path"
  resolve_source "$source_dir"
  source=$resolved_source

  if [ -L "$target" ] && is_managed_link "$path" "$source"; then
    return
  fi

  if [ "$dry_run" = "yes" ]; then
    if path_exists "$target"; then
      echo "Would move ~/$path to a new backup directory"
    fi
    echo "Would symlink ~/$path -> $source"
    return
  fi

  if path_exists "$target"; then
    backup_path "$path" "$target"
  fi

  create_link "$target" "$source"
  echo "Symlink ~/$path -> $source"
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
  install_etc_files
  gen_files
  finish

  echo "Installed dotfiles successfully."
}

install
