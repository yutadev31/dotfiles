{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./system.nix
    ../../profiles/nixos/bluetooth.nix
    ../../profiles/nixos/desktop.nix
    ../../profiles/nixos/dev-workstation.nix
  ];
}
