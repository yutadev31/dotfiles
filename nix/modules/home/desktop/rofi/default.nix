{ pkgs, ... }:
{
  xdg.dataFile."rofi/themes/custom.rasi".source = ./theme.rasi;

  programs.rofi = {
    enable = true;
    theme = "custom";
    settings = {
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };
  };
}
