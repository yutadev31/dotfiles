#!/bin/sh
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git /tmp/paru-aur --depth 1
cd /tmp/paru-aur
makepkg -si
