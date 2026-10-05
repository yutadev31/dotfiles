# Repository Instructions

This repository contains personal dotfiles, a portable shell installer, and a
Nix flake for the `laptop2` NixOS and Home Manager configurations.

## Documentation

- Keep documentation in English.
- Keep `README.md`, this file, and the files directly under `docs/` consistent
  with the scripts, dotlists, and Nix flake.
- Do not modify `docs/notes/**`; these files are personal notes written and
  maintained by the user.

## Runtime and Communication

- This repository may be used from a TTY or while an operating system is being
  installed, when Japanese fonts may not be available. Keep error messages,
  command output, and other operational messages in English.
- Japanese is fine for conversations with the user.

## Portability

- Design the installer and related scripts for Linux as well as BSD-family and
  other Unix-like systems; do not assume Linux-specific behavior unless it is
  explicitly required.
- Prefer POSIX-compliant shell syntax and utilities whenever practical, and
  clearly isolate any platform-specific logic that cannot be avoided.

## Changes

- Preserve existing user changes and avoid unrelated edits.
- Validate documentation changes against the current repository structure and
  script behavior.
- After completing work, output an English commit message that follows the
  Conventional Commits specification.
