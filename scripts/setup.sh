#!/bin/sh
set -euo pipefail

read_password() {
  local prompt="$1"
  local pw
  read -r -s -p "$prompt" pw
  echo    # プロンプトの後に改行
  printf '%s\n' "$pw"
}

disk_dev="/dev/sda"
root_part_pos="512MB"
time_zone="Asia/Tokyo"
lang="en_US.UTF-8"
keymap="jp106"
hostname=""
username="yuta"
shell="fish"
editor="nvim"

root_part_dev="${disk_dev}$([[ $disk_dev == *nvme* ]] && echo p)1"
boot_part_dev="${disk_dev}$([[ $disk_dev == *nvme* ]] && echo p)2"

vendor=$(grep -m1 "vendor_id" /proc/cpuinfo | awk '{print $3}')
if [[ "$vendor" == "GenuineIntel" ]]; then
  ucode="intel-ucode"
elif [[ "$vendor" == "AuthenticAMD" ]]; then
  ucode="amd-ucode"
else
  exit 1
fi

p1=$(read_password "Enter password: ")
p2=$(read_password "Confirm password: ")

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

pacman -S --needed --noconfirm git
git clone http://github.com/yutadev31/dotfiles.git
cd dotfiles

base_packages="$ucode $(cat packages/arch/01_base.txt)"
cli_packages="$(cat packages/arch/02_cli.txt)"
dev_packages="$(cat packages/arch/03_dev.txt)"
desktop_packages="$(cat packages/arch/04_desktop.txt)"
niri_packages="$(cat packages/arch/05_niri.txt)"

echo "Starting installation..."

wipefs -a $disk_dev
parted $disk_dev -- mklabel gpt
parted $disk_dev -- mkpart root ext4 $root_part_pos 100%
parted $disk_dev -- mkpart ESP fat32 1MB $root_part_pos
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
pacman -Sy

pacman -S --noconfirm --needed $cli_packages
pacman -S --noconfirm --needed $dev_packages
pacman -S --noconfirm --needed $desktop_packages
pacman -S --noconfirm --needed $niri_packages

timedatectl set-timezone $time_zone
hwclock --systohc

echo "LANG=$lang" >/etc/locale.conf
echo "KEYMAP=$keymap" >/etc/vconsole.conf

sed -i 's/^#\(en_US\.UTF-8 UTF-8\)/\1/; s/^#\(ja_JP\.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen

echo "$hostname" >/etc/hostname

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
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
