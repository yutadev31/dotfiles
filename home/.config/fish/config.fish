fish_vi_key_bindings

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
alias pacman="sudo pacman"
alias apt="sudo apt"
alias emacs="nvim"
alias vim="nvim"
alias vi="nvim"
alias g="git"
alias gi="git init"
alias gcl="git clone"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gcinit="git commit -m \"Initial commit\""
alias gp="git push"
alias gph="git push -u origin HEAD"
alias gl="git pull --autostash"
alias gr="git remote"
alias gs="git status -sb"
alias gd="git diff"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
alias gbr="git branch -r"
alias gw="git switch"
alias gwm="git switch main"
alias gm="git merge"
alias grh="git reset --hard HEAD"
alias gstash="git stash"
alias gpop="git stash pop"
alias glg="git log --oneline --graph --all --decorate"

set fish_greeting

# bun
export BUN_INSTALL="$HOME/.bun"

# fcitx5
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# Ollama
export OLLAMA_HOST=0.0.0.0

# Mise
mise activate fish | source

export EDITOR=nvim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.bin:$BUN_INSTALL/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"
export GTK_THEME="Adwaita:dark"

source ~/.env.fish

if status --is-login
  if uwsm check may-start && uwsm select
    exec uwsm start default
  end
end
