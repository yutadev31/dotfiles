# Installer Guide

This repository provides separate scripts for installing packages, linking
dotfiles, preparing Paru, and applying Git settings. Run them from the
repository root unless noted otherwise.

## Before You Start

The package and dotfile installers read the untracked `dotconf.sh` file. Create
it from the example and adjust the options for the machine:

```sh
cp dotconf.example.sh dotconf.sh
```

| Option | Accepted values | Default | Effect |
| --- | --- | --- | --- |
| `gui` | `yes`, `no` | `yes` | Includes GUI packages and the `gui` entries in `dotlist.txt`. |
| `vm` | `yes`, `no` | `no` | Selects the VM-specific Sway configuration when GUI files are installed. |

An invalid value, or a missing `dotconf.sh`, stops the relevant installer before
it changes the system.

## `./install.sh`

This is the interactive launcher. It asks separately whether to run package
installation and dotfile installation, in that order. Answer `y`, `Y`, `yes`,
or `YES` to run a step; every other response, including an empty response,
skips it.

```sh
./install.sh
```

Use the individual scripts below when only one operation is wanted, or when a
dry run is needed.

## `./scripts/install-packages.sh`

This script installs packages required by the portable dotfile setup. It uses
`scripts/platform.sh` to detect the operating system and, on Linux, the
distribution from `/etc/os-release`.

| Platform | Result |
| --- | --- |
| Arch Linux | Installs missing packages with `pacman -S --noconfirm --needed`. |
| Void Linux | Stops with a not-implemented error. |
| FreeBSD, OpenBSD, NetBSD, DragonFly BSD | Stops with a not-implemented error. |
| Other platforms or Linux distributions | Stops with an unsupported-platform error. |

On Arch Linux, the base package set is `eza`, `fd`, `fastfetch`, `fish`, `git`,
`git-delta`, `neovim`, and `ripgrep`. With `gui=yes`, it additionally installs
Alacritty, fcitx5 with Mozc, Grim, Mako, Rofi, Slurp, Sway, Waybar, and WayVNC.
It runs `pacman` directly, so run it from an account authorized to install
packages.

```sh
./scripts/install-packages.sh
```

## `./scripts/install-files.sh`

This script installs the paths listed in `dotlist.txt` into `$HOME`. Each entry
is a `base` path (always included) or a `gui` path (included only when
`gui=yes`). It first verifies that every selected source exists and that no
managed paths overlap.

For every selected path, the installer:

1. Leaves an existing symbolic link alone when it already points at this
   repository.
2. Moves a conflicting file, directory, or symbolic link to a new directory
   under `~/.dotfiles-backup/install.XXXXXXXX`.
3. Creates a symbolic link from `$HOME` to the matching path under `home/`.

When GUI files are included, it also generates
`~/.local/share/dotfiles/sway/config-gen` from `config-rm` or `config-vm`,
depending on `vm`. If the installation fails after making changes, it removes
links created during that run and restores the paths it moved to the backup.

Preview the operation without changing `$HOME`:

```sh
./scripts/install-files.sh --dry-run
```

`--help` displays usage. Any other option exits with an error. On NixOS, the
script only runs when `$HOME` is located under `/tmp`; this prevents accidental
use against a regular NixOS home directory.

## `./scripts/install-paru.sh`

This Arch Linux helper installs `base-devel` using `sudo pacman`, clones the
Paru AUR repository into `/tmp/paru-aur`, and runs `makepkg -si` from that
directory.

```sh
./scripts/install-paru.sh
```

It does not perform platform detection, validate prerequisites, or clean up
`/tmp/paru-aur`. Use it only on an Arch-based system with the required build
tools and permissions.

## `./scripts/setup-git.sh`

This helper requires `git` to be available, then writes these global Git
settings for the repository owner:

- `user.name=Yuta`
- `user.email=yuta256dev@gmail.com`
- `init.defaultBranch=main`

```sh
./scripts/setup-git.sh
```

It changes the current user's global Git configuration, so inspect or adapt the
script before running it on another user's machine.
