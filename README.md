# Dotfiles

Personal dotfiles and Nix configuration.

The [`nix/`](./nix/) directory contains NixOS and Home Manager configurations.

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

## Git setup

After installing Git and delta, configure them with:

```sh
./scripts/setup-git.sh
```

## Installation

```sh
git clone https://github.com/yutadev31/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The launcher asks for confirmation before installing packages and dotfiles. The
dotfile installer moves existing managed paths to a unique directory under
`~/.dotfiles-backup`, then creates symbolic links to this repository. If an
installation step fails, it restores paths changed during that run.

Preview the changes without modifying your home directory:

```sh
./scripts/install-files.sh --dry-run
```

## Local configuration

`dotconf.sh` contains machine-specific settings and is not tracked by Git. Create it in the repository root before installing:

```sh
# Install GUI packages and configurations (default: yes)
gui=yes

# Example: use the virtual-machine Sway configuration
vm=yes
```

Set `gui=no` to skip GUI-related packages and configurations, including Sway,
Waybar, Rofi, Mako, Alacritty, fcitx5, wallpapers, and the Sway configuration
generation step.

## License

Unless otherwise noted, this repository is licensed under the [MIT License](./LICENSE).

Some files are subject to different licenses. The applicable license notices for those files can be found in [`LICENSES/`](./LICENSES/).

`home/.local/share/wallpapers/smile_original.png` is an unmodified copy from
[atraxsrc/tokyonight-wallpapers](https://github.com/atraxsrc/tokyonight-wallpapers/blob/main/smile_original.png)
and is licensed under GPL-2.0-only. Its license text and notice are available in
[`LICENSES/`](./LICENSES/).
