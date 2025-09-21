#!/bin/zsh

for script in $HOME/.config/zsh/*.zsh; do
  [ -r "$script" ] && source "$script"
done

source ~/.zshenv
