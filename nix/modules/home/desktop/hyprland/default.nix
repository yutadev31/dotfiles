{ inputs, ... }:
{
  xdg.configFile."hypr/hyprland.lua".source = ../../../../home/.config/hypr/hyprland.lua;
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
