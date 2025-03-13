#!/bin/bash

# Config
DISK="/dev/sda"
BOOT_PART="/dev/sda1"
ROOT_PART="/dev/sda2"
HOSTNAME="vm-arch"
TIMEZONE="Asia/Tokyo"
LANG="ja_JP.UTF-8"
KEYMAP="jp106"

BASE_PACKAGES=$(cat packages/base.txt)

read -p "Do you want to install? (y/N): " answer

if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
  echo "Installation canceled"
  exit 1
fi

# Create partition
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart ESP fat32 1MiB 512MiB
parted -s "$DISK" set 1 boot on
parted -s "$DISK" mkpart primary ext4 512MiB 100%

# Format
mkfs.fat -F32 $BOOT_PART
mkfs.ext4 $ROOT_PART

# Mount
mount --mkdir $ROOT_PART /mnt
mount --mkdir $BOOT_PART /mnt/boot

# Install base system
pacstrap /mnt $BASE_PACKAGES

# Create fstab
genfstab -U /mnt >> /mnt/etc/fstab

# chroot
arch-chroot /mnt <<EOF
# Init package signing key
pacman-key --init
pacman-key --populate archlinux

# Optimize mirrorlist
reflector --protocol https --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

# Update package list
pacman -Sy

# Time Zone
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

# Language
echo "LANG=$LANG" > /etc/locale.conf
sed -i "s/^#$LOCALE/$LOCALE/" /etc/locale.gen
locale-gen

# Hostname
echo "$HOSTNAME" > /etc/hostname

# Keymap
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

# Set root password
echo $ROOT_PASSWORD | passwd --stdin

# Create user
useradd -m -g wheel -s /bin/bash -m $USER_NAME
echo $USER_PASSWORD | passwd --stdin $USER_NAME

# Install Grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --boot-directory=/boot/efi/EFI --recheck
grub-mkconfig -o /boot/efi/EFI/grub/grub.cfg

# Network
systemctl enable networkmanager
EOF
