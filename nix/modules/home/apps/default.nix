{ inputs, pkgs, ... }:
{
  imports = [
    ../programs/vscodium
  ];

  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    discord
    slack
    kdePackages.dolphin
    kdePackages.kde-cli-tools
  ];

  services.syncthing.enable = true;
}
