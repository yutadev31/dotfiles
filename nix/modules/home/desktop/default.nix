{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.slurp
      inputs.shot.packages.${system}.default
      inputs.cpst.packages.${system}.default
      inputs.notify.packages.${system}.default
    ];
    text = builtins.readFile ./screenshot.sh;
  };
in
{
  imports = [
    ./alacritty.nix
    ./dunst.nix
    ./fcitx5.nix
    ./hyprland.nix
    ./rofi.nix
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
    screenshot

    inputs.rubar.packages.${system}.default
    inputs.cpst.packages.${system}.default
    inputs.shot.packages.${system}.default
    inputs.notify.packages.${system}.default
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
