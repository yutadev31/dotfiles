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
    gimp
    inkscape
    blockbench
    blender
    audacity
    vlc
  ];

  programs.google-chrome.enable = true;

  services.syncthing.enable = true;
}
