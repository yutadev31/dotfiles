#!/bin/sh
set -euo pipefail

disk_dev="/dev/sda"
root_part_dev="/dev/sda1"
root_part_pos="512MB"
boot_part_dev="/dev/sda2"
time_zone="Asia/Tokyo"
lang="en_US.UTF-8"
keymap="jp106"
hostname=""
ucode=""
username="yuta"
shell="fish"
editor="nvim"

package_list="networkmanager grub efibootmgr $ucode sudo openssh ufw $shell $editor wget curl"

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
set -euo pipefail

pacman-key --init
pacman-key --populate archlinux

sed 's/^#\(Color\)/\1/' /etc/pacman.conf
pacman -Syu --noconfirm --needed $package_list

timedatectl set-timezone $time_zone
hwclock --systohc

echo "LANG=$lang" >/etc/locale.conf
echo "KEYMAP=$keymap" >/etc/vconsole.conf

sed -i 's/^#\(en_US\.UTF-8 UTF-8\)/\1/; s/^#\(ja_JP\.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen

echo "$hostname" >/etc/hostname

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB_UEFI
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable sshd

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
visudo -c

useradd -m -G wheel -s /bin/$shell $username

echo $password | passwd --stdin
echo $password | passwd $username --stdin

mkinitcpio -P
EOF

arch-chroot /mnt /bin/bash /setup.sh
rm /mnt/setup.sh

echo "Installation completed successfully!"
