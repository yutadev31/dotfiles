#!/bin/sh
set -eu

echo "base=yes"

if [ "$i3" = yes ] || [ "$sway" = yes ] || [ "$hyprland" = yes ]; then
    echo "gui=yes"
else
    echo "gui=no"
fi

echo "i3=$i3"
echo "sway=$sway"
echo "hyprland=$hyprland"

if [ "$i3" = yes ]; then
    echo "x11=yes"
else
    echo "x11=no"
fi

if [ "$sway" = yes ] || [ "$hyprland" = yes ]; then
    echo "wayland=yes"
else
    echo "wayland=no"
fi

echo "vm=$vm"
