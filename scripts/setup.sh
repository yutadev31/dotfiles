#!/bin/sh
set -euo pipefail

disk_dev="/dev/sda"
root_part_dev="/dev/sda1"
root_part_pos="512MB"
boot_part_dev="/dev/sda2"
time_zone="Asia/Tokyo"
lang="en_US.UTF-8"
keymap="jp106"
username="yuta"
shell="fish"
editor="nvim"
package_list="networkmanager sudo openssh ufw $shell $editor"

read -p "Hostname: " hostname
read -s -p "Password: " password

read -p "Do you want to install? (y/N): " answer
answer=${answer:-n}

if [[ ! "$answer" =~ ^[Yy]$ ]]; then
  echo "Installation canceled."
  exit 1
fi

echo "Starting installation..."

parted $disk_dev -- mklabel gpt
parted $disk_dev -- mkpart root ext4 $root_part_pos 100%
parted $disk_dev -- mkpart ESP fat32 1MB $root_part_pos
parted $disk_dev -- set 2 esp on

mkfs.ext4 -L root $root_part_dev
mkfs.fat -F 32 -n boot $boot_part_dev

mount --mkdir $root_part_dev /mnt
mount --mkdir $boot_part_dev /mnt/boot

pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >>/mnt/etc/fstab

cat <<EOF >/mnt/setup.sh
pacman-key --init
pacman-key --populate archlinux

sed 's/^#\(Color\)/\1/' /etc/pacman.conf
pacman -Syu $package_list

timedatectl set-timezone $time_zone
hwclock --systohc

echo "LANG=$lang" >/etc/locale.conf
echo "KEYMAP=$keymap" >/etc/vconsole.conf

sed -i 's/^#\(en_US\.UTF-8 UTF-8\)/\1/; s/^#\(ja_JP\.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen

echo "$hostname" >/etc/hostname

systemctl enable NetworkManager

bootctl --path=/boot install
systemctl enable systemd-boot-update

mv /tmp/loader.conf /boot/loader/loader.conf
mv /tmp/arch.conf /boot/loader/entries/arch.conf

systemctl enable sshd

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
visudo -c

useradd -m -G wheel -s /bin/$shell $username

echo $password | passwd --stdin
echo $password | passwd $username --stdin

mkinitcpio -P
EOF

mkdir -p /mnt/tmp

cat <<EOF >/mnt/tmp/loader.conf
default arch.conf
timeout 0
editor no
EOF

cat <<EOF >/mnt/tmp/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=UUID=$(blkid -s UUID -o value /dev/sda2) rw
EOF

arch-chroot /mnt /bin/bash /setup.sh
rm /mnt/setup.sh

echo "Installation completed successfully!"
