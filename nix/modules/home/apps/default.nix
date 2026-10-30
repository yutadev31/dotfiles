{ pkgs, ... }:
{
  imports = [ ./firefox.nix ];

  home.packages = with pkgs; [
    discord
    slack
    nautilus
    loupe
    vscode
  ];

  services.syncthing.enable = true;
}
