#!/bin/sh
set -eu

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is not installed." >&2
  exit 1
fi

git config --global user.name "Yuta"
git config --global user.email "yuta256dev@gmail.com"
git config --global init.defaultBranch "main"

echo "Configured Git and delta successfully."
