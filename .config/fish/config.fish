if status is-interactive
end

fish_vi_key_bindings

# Env
export EDITOR=nvim
export SHELL=/usr/bin/fish
export LANG=en_US.UTF-8

# Alias
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias mv="mv -i"
alias rm="rm -i"
alias cp="cp -i"
alias cl="clear"
alias ls="eza --icons"
alias l="ls"
alias sl="ls"
alias ll="ls -l"
alias la="ls -la"
alias vi="nvim"
alias vim="nvim"
alias emacs="nvim"
alias nano="nvim"
alias pacman="sudo pacman"
alias apt="sudo apt"
alias reboot="sudo reboot"
alias shutdown="sudo shutdown -h now"
alias g="git"
alias gi="git init"
alias gcl="git clone"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gcinit="git commit -m \"Initial commit\""
alias gp="git push"
alias gl="git pull"
alias gr="git remote"
alias gs="git status -sb"
alias gd="git diff"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
alias gbr="git branch -r"
alias gm="git merge"
alias grh="git reset --hard HEAD"
alias gstash="git stash"
alias gpop="git stash pop"
alias glg="git log --oneline --graph --all --decorate"

# mise
if status is-interactive
  mise activate fish | source
else
  mise activate fish --shims | source
end
