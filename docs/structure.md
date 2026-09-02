# Repository Structure

This repository manages a personal development and desktop environment through
two complementary approaches:

- A portable, shell-based installer that links selected files into `$HOME`.
- A Nix flake that builds NixOS and Home Manager configurations.

The two approaches are maintained side by side. The `home/` tree is used by
the shell installer, while `nix/` contains declarative Nix configurations.

## Top-Level Layout

```text
.
├── home/          Portable dotfiles linked into $HOME
├── nix/           NixOS and Home Manager flake
├── scripts/       Installer and setup helpers
├── docker/        Arch Linux development container
├── docs/          Repository documentation
├── LICENSES/      License notices for included third-party files
├── dotlist.txt    Inventory of paths managed by the portable installer
├── dotconf.sh     Local, machine-specific installer settings (not tracked)
├── flake.nix      Development-shell flake for repository tooling
└── stylua.toml    Lua formatter configuration
```

## Portable Dotfile Installation

`home/` mirrors the relevant portions of a home directory. It contains shell
helpers and application configuration, but its internal files are intentionally
not catalogued here; each top-level path is selected through `dotlist.txt`.

`scripts/install-files.sh` is the entry point for this mode. It reads `dotlist.txt`,
which separates always-installed paths (`base`) from graphical paths
(`gui`). Local options in `dotconf.sh` control whether GUI paths are
included and which generated Sway configuration is used.

Before replacing a managed path, the installer moves it to a timestamped
directory under `~/.dotfiles-backup`. It creates symbolic links only after
preflight checks pass and restores changed paths if installation fails. The
`--dry-run` option previews this process. On NixOS, execution is restricted
to temporary homes under `/tmp` for debugging.

## Nix Configuration

`nix/` is an independent flake with its own lock file and formatter setup.
It provides both NixOS system configurations and Home Manager configurations
for the hosts listed in `nix/flake.nix`.

```text
nix/
├── hosts/
│   └── <host>/    Host-specific hardware, networking, system, and home entry points
├── profiles/
│   ├── nixos/     Reusable system-level feature bundles
│   └── home/      Reusable Home Manager feature bundles
├── modules/
│   ├── nixos/     Focused NixOS modules grouped by base, desktop, and development
│   └── home/      Focused Home Manager modules for base tools, apps, desktop, and more
├── scripts/        Rebuild and garbage-collection helpers
├── flake.nix       NixOS, Home Manager, formatter, and formatting-check outputs
└── flake.lock      Pinned Nix inputs
```

Configuration composition follows this direction:

```text
host → profiles → modules
```

- A host directory declares machine-specific details and chooses profiles.
- Profiles collect related capabilities, such as a desktop or development
  workstation, without containing host-specific details.
- Modules implement those capabilities in small, focused Nix files.

This separation keeps machine details local to `hosts/` and makes shared
system and user-environment features reusable.

## Scripts and Operational Helpers

The repository includes a small set of scripts for routine setup and
maintenance:

- `scripts/install-files.sh` links the selected portable dotfiles into `$HOME`, with
  backups, rollback, and a dry-run mode.
- `scripts/install-packages.sh` installs the packages required by the
  portable setup. It currently implements Arch Linux installation and detects
  several other operating systems.
- `scripts/install-paru.sh` bootstraps the Paru AUR helper on Arch Linux.
- `scripts/setup-git.sh` applies the repository owner's global Git defaults.
- `nix/scripts/os-rebuild` switches the NixOS configuration from the
  `nix/` flake.
- `nix/scripts/home-rebuild` switches the Home Manager configuration for
  the current host.
- `nix/scripts/clean-gc` removes obsolete Nix generations and collects
  unused store paths.

## Development and Container Support

The root `flake.nix` supplies a lightweight development shell with the
formatters used by this repository. The Nix flake additionally exposes a
formatter and a formatting check for its own configuration.

`docker/Dockerfile` defines a minimal Arch Linux-based environment with the
core command-line tools needed to work with the portable setup. It is useful
for isolated development or installer testing without changing a primary
machine.
