#!/bin/sh
set -eu

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is not installed." >&2
  exit 1
fi

if ! command -v delta >/dev/null 2>&1; then
  echo "Error: delta is not installed." >&2
  exit 1
fi

git config --global user.name "Yuta"
git config --global user.email "yuta256dev@gmail.com"
git config --global init.defaultBranch "main"

git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate "true"
git config --global delta.dark "true"
git config --global merge.conflictStyle "zdiff3"

echo "Configured Git and delta successfully."
