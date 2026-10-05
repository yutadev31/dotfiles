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
| `i3` | `yes`, `no` | `yes` | Includes i3, X11 packages, and the `i3` and `x11` entries in the dotlists. |
| `sway` | `yes`, `no` | `yes` | Includes Sway, Wayland packages, and the `sway` and `wayland` entries in the dotlists. |
| `vm` | `yes`, `no` | `no` | Selects the VM-specific Sway configuration when Sway is enabled. |

`gui` is derived internally: it is `yes` when either `i3` or `sway` is
`yes`, and cannot be set in `dotconf.sh`. It selects the common GUI entries in
`dotlist.home.txt` and `dotlist.etc.txt`.

An invalid value, or a missing `dotconf.sh`, stops the relevant installer before
it changes the system.

## `./install.sh`

This runs the portable dotfile installation.

Preview the operation without changing `$HOME`:

```sh
./install.sh --dry-run
```

Package installation remains available as a separate operation below, but is
not run by `install.sh`.

## `./scripts/install-packages.sh`

This script installs packages required by the portable dotfile setup. It uses
`scripts/platform.sh` to detect the operating system and, on Linux, the
distribution from `/etc/os-release`.

| Platform | Result |
| --- | --- |
| Arch Linux | Installs missing packages with `pacman -S --noconfirm --needed`. |
| Void Linux | Installs packages with `xbps-install -S -y`. |
| FreeBSD, OpenBSD, NetBSD, DragonFly BSD | Stops with a not-implemented error. |
| Other platforms or Linux distributions | Stops with an unsupported-platform error. |

On Arch Linux, it installs the CLI and common desktop dependencies. With
`i3=yes`, it additionally installs i3 and Xorg dependencies. With
`sway=yes`, it additionally installs Sway and Wayland dependencies; WayVNC
is installed when `vm=yes`. Void Linux uses the corresponding Void package
names, including `fish-shell`, `font-hack-ttf`, and `xinit`. Both package
managers are run directly, so run the script from an account authorized to
install packages.

```sh
./scripts/install-packages.sh
```

## Dotfile installation details

`install.sh` installs the paths listed in `dotlist.home.txt` into `$HOME` and
the paths listed in `dotlist.etc.txt` into `/etc`. Each entry is a `base` path
(always included), a derived `gui` path, an `i3`/`sway` path selected by the
corresponding option, or an `x11`/`wayland` path selected by the corresponding
WM's platform.
It first verifies that every selected source exists
and that no managed paths overlap. Paths under `/etc` are installed through
`sudo` when the script is not run as root.

For every selected path, the installer:

1. Leaves an existing symbolic link alone when it already points at this
   repository.
2. Moves a conflicting file, directory, or symbolic link to a new directory
   under `~/.dotfiles-backup/install.XXXXXXXX` or
   `/etc/.dotfiles-backup/install.XXXXXXXX`.
3. Creates a symbolic link from the target root to the matching path under
   `home/` or `etc/`.

When Sway files are included, it also generates
`~/.local/share/dotfiles/sway/config-gen` from `config-rm` or `config-vm`,
depending on `vm`. If the installation fails after making changes, it removes
links created during that run and restores the paths it moved to the backup.

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
