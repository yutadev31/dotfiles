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

export EDITOR=nvim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/dev/depot_tools:$PATH"
export GTK_THEME="Catppuccin-Dark-Macchiato"

function fish_command_not_found
    set cmd $argv[1]
    echo "Command '$cmd' not found. Searching packages..."
    set results (pacman -Fq $cmd ^/dev/null)

    if test (count $results) -eq 0
        echo "No packages provide '$cmd'."
    else
        echo (string join ", " $results)
    end
end

# 起動時のメッセージをなしに
function fish_greeting
end
