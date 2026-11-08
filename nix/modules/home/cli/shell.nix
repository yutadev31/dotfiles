{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Disable the startup greeting
      set fish_greeting

      # Delete the previous path component with Ctrl+Backspace
      bind ctrl-backspace backward-kill-path-component

      # Use Vi-style key bindings
      fish_vi_key_bindings

      # Add user-local binaries to PATH
      fish_add_path ~/.bin

      # Log executed commands with timestamps
      function log_command --on-event fish_preexec
        mkdir -p ~/.local/state/fish
        printf '%s\t%s\n' (date '+%Y-%m-%d %H:%M:%S') "$argv" \
          >> ~/.local/state/fish/commands.log
      end

      # List directory contents after changing directories
      function cd
        builtin cd $argv
        ls
      end
    '';

    shellAliases = {
      nd = "nix develop";

      cl = "clear";

      ls = "eza --icons auto";
      l = "ls";
      sl = "ls";
      ll = "ls -l";
      la = "ls -la";

      grep = "grep --color=auto";
      diff = "diff --color=auto";
      mv = "mv -i";
      rm = "rm -i";
      cp = "cp -i";

      nano = "nvim";
      emacs = "nvim";
      vim = "nvim";
      vi = "nvim";

      g = "git";
      gi = "git init";
      gcl = "git clone";
      ga = "git add";
      gaa = "git add .";
      grs = "git restore --staged";
      grsa = "git restore --staged";
      gc = "git commit";
      gca = "git commit --amend";
      gci = "git commit -m 'Initial commit'";
      gp = "git push";
      gph = "git push -u origin HEAD";
      gl = "git pull --autostash";
      gr = "git remote";
      gs = "git status -sb";
      gd = "git diff";
      gdc = "git diff --cached";
      gco = "git checkout";
      gcb = "git checkout -b";
      gb = "git branch";
      gbm = "git branch -M";
      gbd = "git branch -d";
      gbr = "git branch -r";
      gw = "git switch";
      gwm = "git switch main";
      gm = "git merge";
      grh = "git reset --hard HEAD";
      gstash = "git stash";
      gpop = "git stash pop";
      glg = "git log --oneline --graph --all --decorate";
      gt = "git tag";
      gwa = "git worktree add";
    };
  };

  home.shellAliases = {
  };
}
