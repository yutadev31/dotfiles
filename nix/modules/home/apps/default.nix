{ pkgs, ... }:
{
  imports = [ ./firefox.nix ];

  home.packages = with pkgs; [
    slack
    nautilus
    loupe
    vscode
    obsidian
  ];

  services.syncthing.enable = true;
}
