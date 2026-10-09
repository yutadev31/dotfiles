#!/bin/sh

# Load aliases for POSIX-compatible login shells.
if [ -r "$HOME/.config/aliases.sh" ]; then
  . "$HOME/.config/aliases.sh"
fi

# Load .shrc
export ENV="$HOME/.shrc"
