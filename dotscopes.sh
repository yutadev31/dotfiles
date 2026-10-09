#!/bin/sh
set -eu

resolve_scope() {
  value=$1
  cmd=$2

  case "$value" in
  yes | no)
    printf '%s\n' "$value"
    ;;
  auto)
    if command -v "$cmd" >/dev/null 2>&1; then
      printf '%s\n' yes
    else
      printf '%s\n' no
    fi
    ;;
  *)
    printf 'Invalid scope value: %s\n' "$value" >&2
    return 1
    ;;
  esac
}

any_yes() {
  for value in "$@"; do
    if [ "$value" = yes ]; then
      echo yes
      return
    fi
  done

  echo no
}

i3=$(resolve_scope "$i3" i3)
sway=$(resolve_scope "$sway" sway)
hyprland=$(resolve_scope "$hyprland" hyprland)

echo "base=yes"

echo "gui=$(any_yes "$i3" "$sway" "$hyprland")"
echo "x11=$(any_yes "$i3")"
echo "wayland=$(any_yes "$sway" "$hyprland")"

echo "i3=$i3"
echo "sway=$sway"
echo "hyprland=$hyprland"

echo "vm=$vm"
