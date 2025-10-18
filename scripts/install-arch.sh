#!/bin/sh
set -euo pipefail

read_password() {
  local prompt="$1"
  local pw
  read -r -s -p "$prompt" pw
  printf '%s\n' "$pw"
}

get_ucode() {
  vendor=$(grep -m1 "vendor_id" /proc/cpuinfo | awk '{print $3}')
  if [[ "$vendor" == "GenuineIntel" ]]; then
    echo "intel-ucode"
  elif [[ "$vendor" == "AuthenticAMD" ]]; then
    echo "amd-ucode"
  fi
}

source ./config.sh

ucode="$(get_ucode)"
shell="fish"
editor="nvim"

p1=$(read_password "Enter password: ")
echo

p2=$(read_password "Confirm password: ")
echo

if [[ ! "$p1" == "$p2" ]]; then
  echo Error: Passwords do not match.
  exit 1
fi

password="$p1"

read -p "Do you want to install? (y/N): " answer
answer=${answer:-n}

if [[ ! "$answer" =~ ^[Yy]$ ]]; then
  echo "Installation canceled."
  exit 1
fi

base_packages="$ucode $(cat packages/arch/base.txt)"
desktop_packages="$(cat packages/arch/desktop.txt)"

echo "Starting installation..."

wipefs -a $disk_dev
parted $disk_dev -- mklabel gpt
parted $disk_dev -- mkpart root ext4 $root_part_start 100%
parted $disk_dev -- mkpart ESP fat32 1MB $root_part_start
parted $disk_dev -- set 2 esp on

mkfs.ext4 -L root $root_part_dev
mkfs.fat -F 32 -n boot $boot_part_dev

mount --mkdir $root_part_dev /mnt
mount --mkdir $boot_part_dev /mnt/boot

pacstrap -K /mnt $base_packages
genfstab -U /mnt >>/mnt/etc/fstab

cat <<EOF >/mnt/setup.sh
set -euo pipefail

pacman-key --init
pacman-key --populate archlinux

sed 's/^#\(Color\)/\1/' /etc/pacman.conf
pacman -Sy $desktop_packages

timedatectl set-timezone $time_zone
hwclock --systohc

echo "LANG=$lang" >/etc/locale.conf
echo "KEYMAP=$keymap" >/etc/vconsole.conf

sed -i 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sed -i 's/^#\(ja_JP\.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen

echo "$hostname" >/etc/hostname

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable sshd

sed -i 's/^# \(%wheel ALL=(ALL:ALL) ALL\)/\1/' /etc/sudoers
visudo -c

useradd -m -G wheel -s /bin/$shell $username

mkinitcpio -P
EOF

arch-chroot /mnt /bin/bash /setup.sh
rm /mnt/setup.sh

echo $password | arch-chroot /mnt /bin/passwd --stdin
echo $password | arch-chroot /mnt /bin/passwd $username --stdin

echo "Installation completed successfully!"
