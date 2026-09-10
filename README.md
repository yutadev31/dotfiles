# Dotfiles

Personal dotfiles and Nix configuration.

The [`nix/`](./nix/) directory contains NixOS and Home Manager configurations.

## Managed configurations

- Sway, Waybar, Rofi, and Mako
- Alacritty and Fish
- Neovim
- fcitx5
- Git message template and helper scripts

## Installation

Clone the repository and create the local configuration file:

```sh
git clone https://github.com/yutadev31/dotfiles.git ~/dotfiles
cd ~/dotfiles
cp dotconf.example.sh dotconf.sh
```

Edit `dotconf.sh` to suit the machine. Set `gui=no` to skip GUI-related packages
and configurations, including Sway, Waybar, Rofi, Mako, Alacritty, fcitx5,
wallpapers, and Sway configuration generation. Set `vm=yes` to use the
VM-specific Sway configuration.

Then run the interactive installer:

```sh
./install.sh
```

It asks separately whether to install packages and dotfiles, in that order.
The package installer currently installs packages on Arch Linux; package
installation on Void Linux, FreeBSD, OpenBSD, NetBSD, and DragonFly BSD is not
implemented.

The dotfile installer moves existing managed paths to a unique directory under
`~/.dotfiles-backup`, then creates symbolic links to this repository. If an
installation step fails, it restores paths changed during that run.

See the [installer guide](./docs/installers.md) for the behavior, supported
platforms, options, and side effects of every installer and setup helper.

## Post-installation

After installing Git and delta, configure them with:

```sh
./scripts/setup-git.sh
```

## License

Unless otherwise noted, this repository is licensed under the [MIT License](./LICENSE.txt).

Some files are subject to different licenses. The applicable license notices for those files can be found in [`LICENSES/`](./LICENSES/).

`home/.local/share/wallpapers/smile_original.png` is an unmodified copy from
[atraxsrc/tokyonight-wallpapers](https://github.com/atraxsrc/tokyonight-wallpapers/blob/main/smile_original.png)
and is licensed under GPL-2.0-only. Its license text and notice are available in
[`LICENSES/`](./LICENSES/).
