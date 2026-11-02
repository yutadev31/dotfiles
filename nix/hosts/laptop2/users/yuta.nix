{ flake, ... }: {
  imports = [
    flake.homeModules.common
    flake.homeModules.yuta
    flake.homeModules.desktop
  ];

  # Hyprland
  xdg.configFile."hypr/config/monitors.lua".source =
    ../../../../home/.config/hypr/config/monitors.lua/laptop2.lua;
}
