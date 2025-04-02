#!/bin/zsh

fpath=( "$HOME/.config/zsh/functions/" "${fpath[@]}" )

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
