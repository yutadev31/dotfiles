#!/bin/sh
set -eu

dry_run=no
uninstall=no
operation=installation

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run] [--uninstall]

Install the managed dotfiles into $HOME and /etc. Existing paths are moved to
unique backup directories. Paths removed from the dotlists are removed when
they are still symlinks managed by this repository. Use --uninstall to remove
all symlinks recorded by a previous installation. Use --dry-run to preview
changes.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
  --dry-run) dry_run=yes ;;
  --uninstall) uninstall=yes ;;
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
state_root=${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles
state_file=$state_root/installed
moved_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-moved.XXXXXX")
created_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-created.XXXXXX")
etc_moved_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-etc-moved.XXXXXX")
etc_created_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-etc-created.XXXXXX")
stale_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-stale.XXXXXX")
etc_stale_paths=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-etc-stale.XXXXXX")
new_state=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install-state.XXXXXX")

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

  reverse_records "$stale_paths" | while IFS='	' read -r path source; do
    [ -n "$path" ] || continue
    mkdir -p "$(dirname "$HOME/$path")"
    ln -s "$source" "$HOME/$path"
  done

  reverse_records "$etc_stale_paths" | while IFS='	' read -r path source; do
    [ -n "$path" ] || continue
    root_cmd mkdir -p "$(dirname "/etc/$path")"
    root_cmd ln -s "$source" "/etc/$path"
  done
}

reverse_records() {
  awk '{ records[NR] = $0 } END { for (i = NR; i > 0; i--) print records[i] }' "$1"
}

cleanup() {
  status=$?
  if [ "$status" -ne 0 ]; then
    echo "$operation failed; restoring changed paths..." >&2
    rollback
  fi
  rm -f "$moved_paths" "$created_paths" "$etc_moved_paths" "$etc_created_paths" \
    "$stale_paths" "$etc_stale_paths" "$new_state"
  exit "$status"
}

trap cleanup EXIT HUP INT TERM

load_configuration() {
  if [ ! -f "$dotdir/dotconf.sh" ]; then
    echo "Error: $dotdir/dotconf.sh is missing. Create it before running the installer:" >&2
    echo "cp dotconf.example.sh dotconf.sh" >&2
    exit 1
  fi

  set -a
  . "$dotdir/dotconf.sh"
  set +a
  if [ ! -f "$dotdir/dotscopes.sh" ]; then
    echo "Error: $dotdir/dotscopes.sh is missing." >&2
    exit 1
  fi
  if [ ! -x "$dotdir/dotscopes.sh" ]; then
    echo "Error: dotscopes.sh is not executable: $dotdir/dotscopes.sh" >&2
    exit 1
  fi

  options=$(CDPATH= cd -P "$dotdir" && ./dotscopes.sh) || {
    echo "Error: failed to execute: $dotdir/dotscopes.sh" >&2
    exit 1
  }
  enabled_scopes=
  known_scopes=
  seen_scopes='|'
  while IFS= read -r option || [ -n "$option" ]; do
    case "$option" in
    *=*)
      scope=${option%%=*}
      value=${option#*=}
      ;;
    *)
      echo "Error: invalid dotscopes.sh output: $option" >&2
      exit 1
      ;;
    esac
    case "$scope" in
    '' | *[!a-zA-Z0-9_-]*)
      echo "Error: invalid scope in dotscopes.sh output: $scope" >&2
      exit 1
      ;;
    esac
    case "$value" in
    yes | no) ;;
    *)
      echo "Error: scope $scope in dotscopes.sh output must be yes or no." >&2
      exit 1
      ;;
    esac
    case "$seen_scopes" in
    *"|$scope|"*)
      echo "Error: duplicate scope in dotscopes.sh output: $scope" >&2
      exit 1
      ;;
    esac
    seen_scopes=$seen_scopes$scope'|'
    if [ -n "$known_scopes" ]; then known_scopes=$known_scopes,; fi
    known_scopes=$known_scopes$scope
    if [ "$value" = yes ]; then
      if [ -n "$enabled_scopes" ]; then enabled_scopes=$enabled_scopes,; fi
      enabled_scopes=$enabled_scopes$scope
    fi
  done <<EOF
$options
EOF
}

managed_paths() {
  list=${1:?managed_paths: missing list}
  awk -v enabled_scopes="$enabled_scopes" -v known_scopes="$known_scopes" '
    /^[[:space:]]*($|#)/ { next }
    NF != 2 {
      printf "Error: invalid dotlist entry on line %d: expected scope and path\n", NR > "/dev/stderr"
      invalid = 1
      next
    }
    {
      count = split(known_scopes, scopes, ",")
      for (i = 1; i <= count; i++) {
        if ($1 == scopes[i]) {
          enabled_count = split(enabled_scopes, enabled, ",")
          for (j = 1; j <= enabled_count; j++) {
            if ($1 == enabled[j]) {
              print $2
              break
            }
          }
          next
        }
      }
      printf "Error: invalid dotlist scope on line %d: %s\n", NR, $1 > "/dev/stderr"
      invalid = 1
    }
    END { exit invalid }
  ' "$dotdir/$list"
}

state_has_path() {
  state=${1:?state_has_path: missing state}
  scope=${2:?state_has_path: missing scope}
  path=${3:?state_has_path: missing path}

  [ -f "$state" ] || return 1
  awk -F '	' -v expected_scope="$scope" -v expected_path="$path" \
    '$1 == expected_scope && $2 == expected_path { found = 1 } END { exit !found }' "$state"
}

record_state_path() {
  scope=${1:?record_state_path: missing scope}
  path=${2:?record_state_path: missing path}
  source=${3:?record_state_path: missing source}
  printf '%s\t%s\t%s\n' "$scope" "$path" "$source" >>"$new_state"
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

build_state() {
  : >"$new_state"

  while IFS= read -r path; do
    [ -n "$path" ] || continue
    resolve_source "$dotdir/home/$path"
    record_state_path home "$path" "$resolved_source"
  done <<EOF
$(managed_paths dotlist.home.txt)
EOF

  while IFS= read -r path; do
    [ -n "$path" ] || continue
    resolve_source "$dotdir/etc/$path"
    record_state_path etc "$path" "$resolved_source"
  done <<EOF
$(managed_paths dotlist.etc.txt)
EOF
}

remove_stale_links() {
  [ -f "$state_file" ] || return 0

  while IFS='	' read -r scope path source; do
    [ -n "$scope" ] || continue
    state_has_path "$new_state" "$scope" "$path" && continue

    case "$scope" in
    home)
      if is_managed_link "$path" "$source"; then
        rm -f "$HOME/$path"
        printf '%s\t%s\n' "$path" "$source" >>"$stale_paths"
        echo "Remove ~/$path"
      fi
      ;;
    etc)
      if is_managed_etc_link "$path" "$source"; then
        root_cmd rm -f "/etc/$path"
        printf '%s\t%s\n' "$path" "$source" >>"$etc_stale_paths"
        echo "Remove /etc/$path"
      fi
      ;;
    *)
      echo "Warning: ignoring invalid scope in $state_file: $scope" >&2
      ;;
    esac
  done <"$state_file"
}

save_state() {
  mkdir -p "$state_root"
  mv "$new_state" "$state_file"
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

preflight_uninstall() {
  [ -f "$state_file" ] || return 0
  [ "$dry_run" = no ] || return 0
  [ "$(id -u)" -eq 0 ] && return 0

  if awk -F '	' '$1 == "etc" { found = 1 } END { exit !found }' "$state_file"; then
    command -v sudo >/dev/null 2>&1 || {
      echo 'Error: sudo is required to uninstall files under /etc.' >&2
      exit 1
    }
    sudo -v
  fi
}

uninstall_links() {
  if [ ! -f "$state_file" ]; then
    echo "No installed dotfiles state found: $state_file"
    return 0
  fi

  preflight_uninstall
  echo "Uninstalling dotfiles..."

  while IFS='	' read -r scope path source; do
    [ -n "$scope" ] || continue

    case "$scope" in
    home)
      if is_managed_link "$path" "$source"; then
        if [ "$dry_run" = yes ]; then
          echo "Would remove ~/$path"
        else
          rm -f "$HOME/$path"
          printf '%s\t%s\n' "$path" "$source" >>"$stale_paths"
          echo "Remove ~/$path"
        fi
      else
        echo "Leave ~/$path (not a symlink to this repository)"
      fi
      ;;
    etc)
      if is_managed_etc_link "$path" "$source"; then
        if [ "$dry_run" = yes ]; then
          echo "Would remove /etc/$path"
        else
          root_cmd rm -f "/etc/$path"
          printf '%s\t%s\n' "$path" "$source" >>"$etc_stale_paths"
          echo "Remove /etc/$path"
        fi
      else
        echo "Leave /etc/$path (not a symlink to this repository)"
      fi
      ;;
    *)
      echo "Warning: ignoring invalid scope in $state_file: $scope" >&2
      ;;
    esac
  done <"$state_file"

  if [ "$dry_run" = no ]; then
    rm -f "$state_file"
    echo "Remove installed dotfiles state: $state_file"
  fi

  echo "Uninstalled dotfiles successfully."
}

finish() {
  if [ -n "$backup_dir" ]; then
    echo "Backups are available in $backup_dir"
  fi
}

install() {
  echo "Installing dotfiles..."

  preflight
  build_state
  if [ "$dry_run" = "no" ]; then
    remove_stale_links
  fi
  install_files
  install_etc_files
  if [ "$dry_run" = "no" ]; then
    save_state
  fi
  finish

  echo "Installed dotfiles successfully."
}

if [ "$uninstall" = yes ]; then
  operation=uninstallation
  uninstall_links
else
  install
fi
