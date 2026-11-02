{ pkgs, ... }: {
  # Home Manager
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  # Shell
  home.shell.enableFishIntegration = true;

  # Manual
  programs.man.man-db.enable = true;

  # Git
  programs.git.enable = true;

  # SSH
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };

  # Tools
  home.packages = with pkgs; [
    neovim
    curl
    wget
    psmisc
    file
    zip
    unzip
  ];
}
