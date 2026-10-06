# Repository Structure

This repository manages a personal development and desktop environment through
two complementary approaches:

- A portable shell installer that links selected files into `$HOME` and `/etc`.
- A Nix flake that builds the `laptop2` NixOS and Home Manager configurations.

The two approaches are maintained side by side. The `home/` and `etc/` trees
are used by the shell installer, while `nix/` contains declarative Nix
configurations.

## Top-level layout

```text
.
├── home/            Portable dotfiles linked into $HOME
├── etc/             Portable files linked into /etc
├── nix/             NixOS and Home Manager configuration
├── scripts/         Portable installer and Nix helper scripts
├── docs/            Repository documentation
├── LICENSES/        Notices for included third-party files
├── install.sh       Portable dotfile installer
├── dotlist.home.txt Paths installed under $HOME
├── dotlist.etc.txt  Paths installed under /etc
├── dotconf.example.sh
│                    Example machine-specific installer settings
├── flake.nix        NixOS, Home Manager, and development-shell outputs
└── stylua.toml      Lua formatter configuration
```

`dotconf.sh` is created locally from `dotconf.example.sh` and is not tracked.
The repository's `.gitignore` excludes it.

## Portable dotfile installation

`home/` mirrors the relevant portions of a home directory, and `etc/` mirrors
the managed portions of `/etc`. The dotlists select paths with these scopes:

- `base`: always installed
- `gui`: installed when any window manager is enabled
- `i3`, `sway`, `hyprland`: selected window-manager paths
- `x11`, `wayland`: platform-specific paths derived from the window-manager options

`install.sh` validates selected source paths and target overlap before making
changes. It backs up conflicting paths, creates symlinks, and restores moved
paths if the installation fails. `--dry-run` previews the process. On NixOS,
execution is restricted to temporary homes under `/tmp`. Successful installs
record their managed paths in
`${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/installed`; removed dotlist
entries are cleaned up when their links still point into this repository.
`--uninstall` removes recorded links that still point into this repository.

An installed source directory can contain an executable `dotmeta`. The
installer runs it in that directory and links the file whose name it prints;
without `dotmeta`, directories are linked normally. This supports
machine-specific variants while keeping the dotlist path stable.

## Nix configuration

The root `flake.nix` exposes NixOS and Home Manager configurations for the
host listed in the flake (`laptop2`), plus a development shell, formatter, and
formatting check.

```text
nix/
├── hosts/
│   └── laptop2/    Host-specific hardware, networking, system, and home entry points
├── profiles/
│   ├── nixos/      Reusable system-level feature bundles
│   └── home/       Reusable Home Manager feature bundles
└── modules/
    ├── nixos/      Focused NixOS modules for base, desktop, and development
    └── home/       Focused Home Manager modules for tools, apps, and desktop
```

Configuration composition follows this direction:

```text
host → profiles → modules
```

The host directory chooses profiles, profiles collect related capabilities,
and modules implement those capabilities in focused Nix files.

## Scripts and operational helpers

- `install.sh` links selected portable dotfiles with backup, rollback, and
  dry-run support.
- `scripts/install-packages.sh` installs the portable setup's packages on
  Arch Linux or Void Linux.
- `scripts/install-paru.sh` bootstraps the Paru AUR helper on Arch Linux.
- `scripts/setup-git.sh` applies the repository owner's global Git defaults.
- `scripts/os-rebuild` switches the NixOS configuration from the root flake.
- `scripts/home-rebuild` switches the Home Manager configuration selected by
  `$HOSTNAME`.
- `scripts/clean-gc` removes obsolete Nix generations and collects unused
  store paths.

## Development support

The root flake provides a development shell with language servers and
formatters, as well as a formatter and formatting check for the Nix
configuration.
