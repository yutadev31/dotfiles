#!/bin/zsh

for script in $HOME/.config/zsh/*.zsh; do
  [ -r "$script" ] && source "$script"
done

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/yuta/.lmstudio/bin"
