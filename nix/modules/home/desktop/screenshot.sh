#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 ]]; then
  printf 'Usage: screenshot --all | --monitor | --region\n' >&2
  exit 2
fi

shot_args=()
case $1 in
  --all) ;;
  --monitor | --region)
    slurp_args=()
    if [[ $1 == --monitor ]]; then
      slurp_args=(-o)
    fi

    selection=$(slurp "${slurp_args[@]}")
    read -r position size <<< "$selection"
    if [[ -z $position || -z $size ]]; then
      printf 'No screenshot region selected.\n' >&2
      exit 1
    fi

    shot_args=(-r "$position" "$size")
    ;;
  *)
    printf 'Usage: screenshot --all | --monitor | --region\n' >&2
    exit 2
    ;;
esac

directory=$HOME/Pictures/Screenshots
mkdir -p -- "$directory"

timestamp=$(date +'%Y%m%d_%H%M%S')
file=$directory/$timestamp.png
temporary=$(mktemp -- "$directory/.screenshot.XXXXXXXX")
trap 'rm -f -- "$temporary"' EXIT

shot "${shot_args[@]}" > "$temporary"

suffix=0
until ln -T -- "$temporary" "$file" 2>/dev/null; do
  if [[ ! -e $file && ! -L $file ]]; then
    printf 'Could not save screenshot to %s.\n' "$file" >&2
    exit 1
  fi

  suffix=$((suffix + 1))
  file=$directory/${timestamp}_$suffix.png
done

cpy < "$temporary"
notify 'Screenshot copied to clipboard' "$file"
