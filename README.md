# Dotfiles

Personal dotfiles for non-NixOS environments.

## Managed configurations

- Sway, Waybar, Rofi, and Mako
- Alacritty and Fish
- Neovim
- fcitx5
- Git message template and helper scripts

## Requirements

Install the required packages before running the installer. A package-installation helper is included:

```sh
./scripts/install-packages.sh
```

The helper installs packages on Arch Linux. It also detects Void Linux, FreeBSD,
OpenBSD, NetBSD, and DragonFly BSD, but package installation for those systems is
not implemented yet and exits with an error.

## Installation

```sh
git clone https://github.com/yutadev31/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer moves an existing managed path to a matching `*.old` path, then creates a symbolic link to this repository.

## Local configuration

`dotconf.sh` contains machine-specific settings and is not tracked by Git. Create it in the repository root before installing:

```sh
# Example: use the virtual-machine Sway configuration
vm=yes
```

## License

Unless otherwise noted, this repository is licensed under the [MIT License](./LICENSE).

Some files are subject to different licenses. The applicable license notices for those files can be found in [`LICENSES/`](./LICENSES/).

`home/.local/share/wallpapers/smile_original.png` is an unmodified copy from
[atraxsrc/tokyonight-wallpapers](https://github.com/atraxsrc/tokyonight-wallpapers/blob/main/smile_original.png)
and is licensed under GPL-2.0-only. Its license text and notice are available in
[`LICENSES/`](./LICENSES/).
