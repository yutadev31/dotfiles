#!/bin/bash
set -euo pipefail

GREEN='\033[1;32m'
RESET='\033[0m'

log() {
  echo -e "\${GREEN}[*] \$1\${RESET}"
}

source /tmp/vars.sh

log "Initializing pacman keys..."
pacman-key --init
pacman-key --populate archlinux

log "Enabling colors in pacman..."
sed -i 's/^#\(Color\)/\1/' /etc/pacman.conf

log "Download package databases..."
pacman -Sy

log "Configuring timezone and clock..."
timedatectl set-timezone $time_zone
hwclock --systohc

log "Setting locale and keyboard layout..."
echo "LANG=$lang" >/etc/locale.conf
echo "KEYMAP=$keymap" >/etc/vconsole.conf
sed -i 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen

log "Setting hostname..."
echo "$hostname" >/etc/hostname

log "Installing GRUB bootloader..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

log "Enabling essential services..."
systemctl enable NetworkManager sshd

log "Configuring /etc/hosts..."
cat <<EOF >/etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain $hostname
EOF

log "Configuring NetworkManager to use Cloudflare DNS..."
mkdir -p /etc/NetworkManager/conf.d
cat <<EOF >/etc/NetworkManager/conf.d/dns.conf
[main]
dns=none
EOF

log "Setting Cloudflare DNS..."
cat <<EOF >/etc/resolv.conf
nameserver 1.1.1.2
nameserver 1.0.0.2
EOF

log "Configuring sudo permissions..."
sed -i 's/^# \(%wheel ALL=(ALL:ALL) ALL\)/\1/' /etc/sudoers
visudo -c

log "Creating user '$username'..."
useradd -m -G wheel -s /bin/$shell $username

log "Generating initramfs..."
mkinitcpio -P

rm /post-install.sh
