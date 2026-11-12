{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ./alacritty
    ./dunst
    ./fcitx5
    ./hyprland
    ./rofi
    ./keyring.nix
    ./theme.nix
    ./apps
  ];

  home.packages = with pkgs; [
    xdg-user-dirs
    xdg-utils
    dconf
    wl-clipboard # includes wl-copy & wl-paste
    wlr-utils
    grim
    slurp
    playerctl
    pavucontrol
    brightnessctl
    hyprpicker
    libnotify # includes notify-send
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome

    inputs.rubar.packages.${system}.default
    inputs.cpst.packages.${system}.default
    inputs.shot.packages.${system}.default
  ];

  xdg.configFile."rubar/config.toml".source = ../../../../home/.config/rubar/config.toml;

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 35.6;
    longitude = 139.6;
    temperature = {
      day = 5000;
      night = 4000;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";

      "inode/directory" = "org.gnome.Nautilus.desktop";
      "image/*" = "org.gnome.Loupe.desktop";
    };
  };
}
