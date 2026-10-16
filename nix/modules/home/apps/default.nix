{ inputs, pkgs, ... }:
{
  imports = [ ./firefox.nix ];

  home.packages = with pkgs; [
    discord
    slack
    nautilus
  ];

  services.syncthing.enable = true;
}
