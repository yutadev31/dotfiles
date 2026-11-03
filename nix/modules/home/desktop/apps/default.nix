{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./games.nix
  ];

  home.packages = with pkgs; [
    slack
    nautilus
    loupe
    vscode
    obsidian
  ];

  programs.google-chrome.enable = true;

  services.syncthing.enable = true;
}
