#!/bin/bash

sudo pacman -Syu --needed \
  base base-devel \
  zip unzip \
  curl wget \
  git github-cli \
  zsh tmux starship \
  vim neovim helix \
  fastfetch \
  man-db man-pages \
  nodejs npm yarn pnpm \
  cmake nasm rustup \
  openssh translate-shell tree zip unzip
