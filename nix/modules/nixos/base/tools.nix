{ pkgs, ... }:
{
  # System Tools
  environment.systemPackages = with pkgs; [
    neovim
    curl
    wget
    psmisc
    file
    zip
    unzip
  ];
}
