{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    discord
    slack
    nautilus
  ];

  services.syncthing.enable = true;
}
