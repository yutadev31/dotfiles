# Repository Guidelines

This repository contains dotfiles, a portable shell installer, and NixOS/Home Manager configurations.

## Documentation

- Write documentation and operational messages in English.
- Keep documentation consistent with the repository's implementation.
- Never modify `docs/notes/**`.
- Japanese is allowed in user conversations.

## Portability

- Support Linux, BSD, and other Unix-like systems.
- Prefer POSIX-compliant shell syntax and utilities.
- Isolate platform-specific behavior.

## Git

- Never modify `main` unless explicitly instructed.
- Repository-modifying Git operations are allowed on other branches.
- After completing a task, run relevant checks, review the diff, and commit only task-related changes.
- Use English Conventional Commits messages.
- Never push or rewrite history unless explicitly instructed.
