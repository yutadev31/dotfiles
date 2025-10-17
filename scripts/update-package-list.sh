#!/bin/sh
pacman -Qqe > packages/hosts/$(hostnamectl hostname).txt
