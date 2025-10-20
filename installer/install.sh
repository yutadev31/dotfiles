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
shell="fish"

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
pacstrap -K /mnt $(cat packages/base.txt) $firmware

log "Generating fstab..."
genfstab -U /mnt >>/mnt/etc/fstab

log "Copying post-install script..."
cp post-install.sh /mnt/post-install.sh
mkdir /mnt/tmp && cp config.sh /mnt/tmp/config.sh

log "Running chroot setup..."
arch-chroot /mnt /post-install.sh

log "Setting root and user passwords..."
echo "$password" | arch-chroot /mnt /bin/passwd --stdin
echo "$password" | arch-chroot /mnt /bin/passwd "$username" --stdin

log "Installing desktop..."
arch-chroot /mnt /bin/pacman -S --needed --noconfirm $(cat packages/desktop.txt)

echo -e "${GREEN}Installation completed successfully!${RESET}"
