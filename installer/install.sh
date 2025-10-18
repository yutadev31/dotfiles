#!/bin/bash
set -euo pipefail

# ===== Color setup =====
GREEN='\033[1;32m'
RED='\033[1;31m'
RESET='\033[0m'

log() {
  echo -e "${GREEN}[*] $1${RESET}"
}

error() {
  echo -e "${RED}[!] $1${RESET}" >&2
}

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

add_partition() {
  local device="$1"
  local num="$2"

  if [[ "$device" == /dev/nvme* || "$device" == /dev/mmcblk* ]]; then
    echo "${device}p${num}"
  else
    echo "${device}${num}"
  fi
}

log "Loading configuration..."
source ./config.sh

boot_part_dev="$(add_partition $disk_dev 1)"
root_part_dev="$(add_partition $disk_dev 2)"

ucode="$(get_ucode)"

p1=$(read_password "Enter password: ")
echo

p2=$(read_password "Confirm password: ")
echo

if [[ ! "$p1" == "$p2" ]]; then
  error "Passwords do not match."
  exit 1
fi

password="$p1"

read -p "Do you want to install? (y/N): " answer
answer=${answer:-n}

if [[ ! "$answer" =~ ^[Yy]$ ]]; then
  log "Installation canceled."
  exit 1
fi

log "Starting installation..."

log "Wiping disk..."
wipefs -a "$disk_dev"

log "Creating partitions..."
parted "$disk_dev" -- mklabel gpt
parted "$disk_dev" -- mkpart ESP fat32 1MB "$root_part_start"
parted "$disk_dev" -- set 1 esp on
parted "$disk_dev" -- mkpart root ext4 "$root_part_start" 100%

log "Formatting partitions..."
mkfs.fat -F 32 -n boot "$boot_part_dev"
mkfs.ext4 -L root "$root_part_dev"

log "Mounting partitions..."
mount --mkdir "$root_part_dev" /mnt
mount --mkdir "$boot_part_dev" /mnt/boot

log "Installing base system..."
pacstrap -K /mnt $(cat packages/base.txt)

log "Generating fstab..."
genfstab -U /mnt >>/mnt/etc/fstab

log "Creating post-install script..."
cat <<EOF >/mnt/post-install.sh
set -euo pipefail

GREEN='\033[1;32m'
RESET='\033[0m'

log() {
  echo -e "\${GREEN}[*] \$1\${RESET}"
}

log "Initializing pacman keys..."
pacman-key --init
pacman-key --populate archlinux

log "Enabling colors in pacman..."
sed -i 's/^#\(Color\)/\1/' /etc/pacman.conf

log "Download package databases..."
pacman -Syu

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
cat <<END >/etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain $hostname
END

log "Configuring NetworkManager to use Cloudflare DNS..."
mkdir -p /etc/NetworkManager/conf.d
cat <<END >/etc/NetworkManager/conf.d/dns.conf
[main]
dns=none
END

log "Setting Cloudflare DNS..."
cat <<END >/etc/resolv.conf
nameserver 1.1.1.2
nameserver 1.0.0.2
END

log "Configuring sudo permissions..."
sed -i 's/^# \(%wheel ALL=(ALL:ALL) ALL\)/\1/' /etc/sudoers
visudo -c

log "Creating user '$username'..."
useradd -m -G wheel -s /bin/$shell $username

log "Generating initramfs..."
mkinitcpio -P

rm /post-install.sh
EOF

log "Running chroot setup..."
arch-chroot /mnt /bin/bash /post-install.sh

log "Setting root and user passwords..."
echo "$password" | arch-chroot /mnt /bin/passwd --stdin
echo "$password" | arch-chroot /mnt /bin/passwd "$username" --stdin

echo -e "${GREEN}Installation completed successfully!${RESET}"
