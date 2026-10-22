{ pkgs, ... }:
{
  imports = [ ./firefox.nix ];

  home.packages = with pkgs; [
    discord
    slack
    nautilus
    vscode
  ];

  services.syncthing.enable = true;
}
