{ inputs, pkgs, ... }:
{
  imports = [ ./firefox.nix ];

  home.packages = with pkgs; [
    slack
    nautilus
  ];

  services.syncthing.enable = true;
}
