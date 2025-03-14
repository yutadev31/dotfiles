#!/bin/zsh

function mkcd() {
  mkdir -p "$1"
  cd "$1"
}

function srm() {
  mkdir -p ~/.trash
  mv "$@" ~/.trash
}

function dsize() {
  du -sh "$@"
}

function fsearch() {
  find . -name "$1"
}

function pmon() {
  ps aux | grep "$1"
}

# Git
function gitunpushed() { git log origin/$(git rev-parse --abbrev-ref HEAD)..HEAD --oneline; }
function gitclean() { git branch --merged | grep -v "\*" | xargs -n 1 git branch -d; }
function gitbranch() { git rev-parse --abbrev-ref HEAD; }
function gittags() { git tag --sort=-creatordate; }

function countlines() {
  wc -l "$1"
}

function today() { date "+%Y-%m-%d"; }

