#!/bin/sh
set -eu

# Load aliases for bash.
if [ -r "$HOME/.config/aliases.sh" ]; then
  . "$HOME/.config/aliases.sh"
fi
