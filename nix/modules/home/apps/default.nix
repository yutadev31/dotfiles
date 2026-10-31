{ pkgs, ... }:
{
  imports = [ ./firefox.nix ];

  home.packages = with pkgs; [
    slack
    nautilus
    loupe
    vscode
  ];

  services.syncthing.enable = true;
}
