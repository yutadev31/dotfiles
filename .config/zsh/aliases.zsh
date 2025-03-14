#!/bin/zsh

alias '$'=

# --color=auto
alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias diff="diff --color=auto"

# -i
alias mv="mv -i"
alias rm="rm -i"
alias rmrf="rm -rf"
alias cp="cp -i"

alias cl="clear"
alias rmdir="rm -r"

# ls
alias l="ls"
alias sl="ls"
alias ll="ls -l"
alias la="ls -la"
alias lscd="ls && cd"

# sudo
alias pacman="sudo pacman"
alias apt="sudo apt"
alias reboot="sudo reboot"
alias shutdown="sudo shutdown -h now"

# cd
alias dev="cd ~/dev"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."  # 上の階層に一気に移動

# git
alias lg="lazygit"
alias g="git"
alias gi="git init"
alias gcl="git clone"
alias gclone="git clone"
alias ga="git add"
alias gadd="git add"
alias gaa="git add ."
alias gc="git commit"
alias gcommit="git commit"
alias gcinit="git commit -m \"Initial commit\""
alias gp="git push"
alias gpush="git push"
alias gl="git pull"
alias gpull="git pull"
alias gr="git remote"
alias gremote="git remote"
alias gru="git remote get-url origin"
alias gs="git status -sb"
alias gd="git diff"
alias gdiff="git diff"
alias gco="git checkout"
alias gcheckout="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
alias gbranch="git branch"
alias gbr="git branch -r"
alias gm="git merge"
alias gmerge="git merge"
alias grh="git reset --hard HEAD"
alias gstash="git stash"
alias gpop="git stash pop"
alias glg="git log --oneline --graph --all --decorate"
