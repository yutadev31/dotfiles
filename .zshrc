#!/bin/zsh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

for script in $HOME/.config/zsh/*.zsh; do
  [ -r "$script" ] && source "$script"
done

# bun completions
[ -s "/home/yuta/.bun/_bun" ] && source "/home/yuta/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
