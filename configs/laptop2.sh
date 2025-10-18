#!/bin/sh

export disk_dev="/dev/nvme0n1"
export root_part_dev="/dev/nvme0n1p1"
export boot_part_dev="/dev/nvme0n1p2"
export root_part_start="512MB"
export time_zone="Asia/Tokyo"
export lang="en_US.UTF-8"
export keymap="jp106"
export hostname="vm"
export username="yuta"
export dotfiles_url="https://github.com/yutadev31/dotfiles.git"
export dotfiles_install="./install.sh hyprland"
