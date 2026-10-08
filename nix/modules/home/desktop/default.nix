{ pkgs, inputs, ... }:
{
  imports = [
    ./alacritty
    ./dunst
    ./fcitx5
    ./hyprland
    ./rofi
    ./keyring.nix
    ./theme.nix
  ];

  home.packages =
    with pkgs;
    [
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
    ]
    ++ [
      inputs.cpst.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.shot.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.rubar.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  xdg.configFile."shot/config.toml".source = ../../../../home/.config/shot/config.toml;
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
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
    };
  };
}
