#!/bin/zsh
setopt auto_cd
setopt hist_ignore_dups
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
bindkey "^[[3~" delete-char
