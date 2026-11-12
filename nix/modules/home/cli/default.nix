{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ./agents
    ./neovim.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    tlrc
    fastfetch

    inputs.trash.packages.${system}.default
  ];

  # Btop (top)
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-storm";
      theme_background = false;
      vim_keys = true;
    };
  };

  # Fd (find)
  programs.fd.enable = true;

  # Ripgrep (grep)
  programs.ripgrep.enable = true;

  # Eza (ls)
  programs.eza.enable = true;

  # Fzf
  programs.fzf.enable = true;

  # Git
  programs.git = {
    enable = true;
    settings = {
      user.name = "Yuta";
      user.email = "yuta256dev@gmail.com";
      init.defaultBranch = "main";
      user.signingkey = "732638DCBAA59D65";
      commit.gpgsign = true;
    };
  };

  # GitHub CLI
  programs.gh.enable = true;
}
