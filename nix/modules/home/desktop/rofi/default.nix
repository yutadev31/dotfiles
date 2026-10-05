{ pkgs, ... }:
{
  xdg.dataFile."rofi/themes/tokyonight.rasi".source =
    ../../../../../home/.local/share/rofi/themes/tokyonight.rasi;

  programs.rofi = {
    enable = true;
    theme = "tokyonight";
    settings = {
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };
  };
}
