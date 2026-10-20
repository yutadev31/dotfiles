{ pkgs, ... }:
{
  imports = [ ./firefox.nix ];

  home.packages = with pkgs; [
    slack
    nautilus
    vscode
  ];

  services.syncthing.enable = true;
}
