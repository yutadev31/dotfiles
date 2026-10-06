# Dotfiles

Personal dotfiles and Nix configuration for an `x86_64-linux` system.

This repository supports two installation paths:

- A portable shell installer that links selected files into `$HOME` and `/etc`.
- A Nix flake that builds the `laptop2` NixOS and Home Manager configurations.

## Managed configurations

- Shell and CLI tools: Fish, Fastfetch, tmux, Git, and Neovim
- Desktop applications: Alacritty, Dunst, Fcitx5, Rofi, and custom Rubar/Shot configuration
- Window managers and compositors: i3, Sway, and Hyprland
- NixOS and Home Manager modules, profiles, and host configuration
- Tokyo Night themes and wallpapers

## Portable installation

Clone the repository and create the local configuration file:

```sh
git clone https://github.com/yutadev31/dotfiles.git ~/dotfiles
cd ~/dotfiles
cp dotconf.example.sh dotconf.sh
```

Edit `dotconf.sh` for the machine. The current example disables i3, Sway,
Hyprland, and VM-specific Sway configuration by default. Set each option to
`yes` or `no` as needed:

```sh
i3=no
sway=no
hyprland=no
vm=no
```

Run the dotfile installer:

```sh
./install.sh
```

Use `--dry-run` to preview the operation:

```sh
./install.sh --dry-run
```

Use `--uninstall` to remove symlinks recorded by a previous installation:

```sh
./install.sh --uninstall
```

`install.sh` does not install packages. The separate package helper supports
Arch Linux and Void Linux; it reports unsupported platforms and does not yet
install packages on FreeBSD, OpenBSD, NetBSD, or DragonFly BSD:

```sh
./scripts/install-packages.sh
```

The dotfile installer reads `dotlist.home.txt` and `dotlist.etc.txt`, moves
conflicting managed paths into unique directories under
`~/.dotfiles-backup` or `/etc/.dotfiles-backup`, and creates symbolic links to
this repository. It records installed paths under
`${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/installed`; paths removed from
the dotlists are automatically removed when they are still links to this
repository. `--uninstall` removes recorded links that still point to this
repository and leaves changed or unrelated paths untouched. It uses `sudo` for
`/etc` paths when necessary and rolls back changes made during a failed
installation. On NixOS, it only runs when
`$HOME` is under `/tmp`.

See the [installer guide](./docs/installers.md) for options, supported
platforms, backups, rollback, and helper scripts. See the
[dependency guide](./docs/dependencies.md) for non-Nix package requirements.

## Nix installation

The root `flake.nix` exposes NixOS and Home Manager configurations for
`laptop2`, along with a development shell, formatter, and formatting check.
The repository's Nix rebuild helpers are:

```sh
./scripts/os-rebuild
./scripts/home-rebuild
./scripts/clean-gc
```

The Home Manager helper uses `$HOSTNAME` to select the host configuration.
Inspect the flake and host files before applying a configuration on another
machine.

## Git setup

After installing Git, optionally apply the repository owner's global defaults:

```sh
./scripts/setup-git.sh
```

This sets `user.name`, `user.email`, and `init.defaultBranch` for the current
user. Review the script before running it for another user.

## License

Unless otherwise noted, this repository is licensed under the [MIT License](./LICENSE.txt).

Some files are subject to different licenses. The applicable license notices
are in [`LICENSES/`](./LICENSES/). The included
`home/.local/share/wallpapers/smile_original.png` is an unmodified copy from
[atraxsrc/tokyonight-wallpapers](https://github.com/atraxsrc/tokyonight-wallpapers/blob/main/smile_original.png)
and is licensed under GPL-2.0-only.
