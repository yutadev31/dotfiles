{ inputs, ... }:
{
  xdg.configFile."hypr/hyprland.lua".source = ../../../../../home/.config/hypr/hyprland.lua;
  xdg.configFile."hypr/config/monitors.lua".source =
    ../../../../../home/.config/hypr/config/monitors.lua/laptop2.lua;
  xdg.configFile."hypr/config/animations.lua".source =
    ../../../../../home/.config/hypr/config/animations.lua;
  xdg.configFile."hypr/config/appearance.lua".source =
    ../../../../../home/.config/hypr/config/appearance.lua;
  xdg.configFile."hypr/config/input.lua".source = ../../../../../home/.config/hypr/config/input.lua;
  xdg.configFile."hypr/config/keybinds.lua".source =
    ../../../../../home/.config/hypr/config/keybinds.lua;
  xdg.configFile."hypr/config/programs.lua".source =
    ../../../../../home/.config/hypr/config/programs.lua;
  xdg.configFile."hypr/plugins/split-monitor-workspaces".source = inputs.split-monitor-workspaces;

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland compositor session";
      Documentation = [ "man:systemd.special" ];

      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

}
