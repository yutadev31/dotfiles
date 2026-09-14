{ pkgs, pkgs-voicevox, ... }:
{
  home.packages =
    with pkgs;
    [
      kdePackages.kdenlive
      gimp
      inkscape
      audacity
      blender
      vlc
      qgis
    ]
    ++ [ pkgs-voicevox.voicevox ];

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
}
