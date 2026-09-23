# Disable the startup greeting
set fish_greeting

# Set Neovim as the default editor
set -x EDITOR nvim

# Add NetBSD X11 binaries to PATH
if test (uname) = NetBSD
  fish_add_path /usr/X11R7/bin
end

# Add user-local binaries to PATH
fish_add_path ~/.bin

# Use Vi-style key bindings
fish_vi_key_bindings

# Load aliases
source ~/.config/aliases.sh

# Log executed commands with timestamps
function log_command --on-event fish_preexec
  mkdir -p ~/.local/state/fish
  printf '%s\t%s\n' (date '+%Y-%m-%d %H:%M:%S') "$argv" \
    >> ~/.local/state/fish/commands.log
end
