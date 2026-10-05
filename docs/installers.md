# Installer Guide

This repository provides separate scripts for installing packages, linking
portable dotfiles, bootstrapping Paru, applying Git settings, and rebuilding
Nix configurations. Run the scripts from the repository root unless noted
otherwise.

## Before you start

The portable installers read the untracked `dotconf.sh`. Create it from the
example and adjust the options for the machine:

```sh
cp dotconf.example.sh dotconf.sh
```

| Option | Values | Default | Effect |
| --- | --- | --- | --- |
| `i3` | `yes`, `no` | `no` in the example; `yes` if omitted | Enables i3, X11 packages, and i3/X11 dotlist entries |
| `sway` | `yes`, `no` | `no` in the example; `yes` if omitted | Enables Sway, Wayland packages, and Sway/Wayland dotlist entries |
| `hyprland` | `yes`, `no` | `no` | Enables Hyprland and its dotlist/package entries |
| `vm` | `yes`, `no` | `no` | Selects the VM-specific Sway config and installs WayVNC with Sway |

The example explicitly sets all four values to `no`. The scripts apply the
defaults shown in the table when an option is absent from a custom
`dotconf.sh`. `gui` is derived internally from the three window-manager
options and cannot be set in `dotconf.sh`. `x11` follows `i3`; `wayland` is
enabled by Sway or Hyprland.

Invalid values or a missing `dotconf.sh` stop the relevant script before it
changes the system.

## `./install.sh`

This installs the selected portable dotfiles. It does not install packages.

```sh
./install.sh
./install.sh --dry-run
```

The dry run previews the operation without changing `$HOME` or `/etc`.
`--help` displays usage; any other option is rejected.

The installer reads `dotlist.home.txt` for paths under `$HOME` and
`dotlist.etc.txt` for paths under `/etc`. It preflights selected source paths
and overlapping targets before changing anything. For each selected path it:

1. Leaves a symlink alone when it already points to this repository.
2. Moves a conflicting file, directory, or symlink to a unique directory
   under `~/.dotfiles-backup/install.XXXXXXXX` or
   `/etc/.dotfiles-backup/install.XXXXXXXX`.
3. Creates a symlink to the matching path in `home/` or `etc/`.

Paths under `/etc` use `sudo` when the script is not run as root. When Sway is
selected, the installer also generates
`~/.local/share/dotfiles/sway/config-gen` from `config-rm` or `config-vm`,
depending on `vm`. If installation fails after changes, it removes links
created during that run and restores moved paths.

On NixOS, `install.sh` only runs when `$HOME` is under `/tmp`; this prevents
accidental use against a regular NixOS home directory.

## `./scripts/install-packages.sh`

This script detects the operating system with `scripts/platform.sh` and, on
Linux, reads the distribution from `/etc/os-release`.

| Platform | Result |
| --- | --- |
| Arch Linux | Installs missing packages with `pacman -S --noconfirm --needed` |
| Void Linux | Installs packages with `xbps-install -S -y` |
| FreeBSD, OpenBSD, NetBSD, DragonFly BSD | Stops with a not-implemented error |
| Other platforms or Linux distributions | Stops with an unsupported-platform error |

The selected package groups follow `dotconf.sh`. Both package managers run
with the current user's permissions, so use an account authorized to install
packages. See [dependencies](./dependencies.md) for the package groups.

## `./scripts/install-paru.sh`

This Arch Linux helper installs `base-devel` with `sudo pacman`, clones the
Paru AUR repository into `/tmp/paru-aur`, and runs `makepkg -si` there:

```sh
./scripts/install-paru.sh
```

It does not perform platform detection, validate prerequisites, or remove an
existing `/tmp/paru-aur`. Use it only on an Arch-based system and inspect the
target directory before rerunning it.

## `./scripts/setup-git.sh`

This helper requires Git and writes these global settings for the current user:

- `user.name=Yuta`
- `user.email=yuta256dev@gmail.com`
- `init.defaultBranch=main`

```sh
./scripts/setup-git.sh
```

Review or adapt the script before using it for another user.

## Nix helpers

The root flake defines the `laptop2` NixOS and Home Manager configurations:

```sh
./scripts/os-rebuild    # sudo nixos-rebuild switch --flake .
./scripts/home-rebuild  # home-manager switch --flake .#$HOSTNAME
./scripts/clean-gc      # remove old generations and collect the store
```

Inspect the scripts and the flake before applying them on a different host.
