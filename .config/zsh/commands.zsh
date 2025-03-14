#!/bin/zsh

function mkcd() {
  mkdir -p "$1"
  cd "$1"
}

function srm() {
  mkdir -p ~/.trash
  mv "$@" ~/.trash
}
