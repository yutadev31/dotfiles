{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./games.nix
  ];

  home.packages = with pkgs; [
    slack
    nautilus
    loupe
    vscode
    obsidian

    kdePackages.kdenlive
    gimp
    inkscape
    audacity
    blender
    vlc
    qgis
    voicevox
  ];

  programs.google-chrome.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

  services.syncthing.enable = true;
}
