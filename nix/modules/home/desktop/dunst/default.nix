{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Hack Nerd Font 10";
        origin = "top-right";
        offset = "12x42";
        width = 360;
        frame_width = 2;
        corner_radius = 8;
        padding = 12;
        horizontal_padding = 12;
        text_icon_padding = 8;
        separator_height = 2;
        frame_color = "#3d59a1";
        separator_color = "frame";
      };

      urgency_low = {
        background = "#1a1b26";
        foreground = "#a9b1d6";
        timeout = 5;
      };

      urgency_normal = {
        background = "#24283b";
        foreground = "#c0caf5";
        frame_color = "#7aa2f7";
        timeout = 10;
      };

      urgency_critical = {
        background = "#24283b";
        foreground = "#f7768e";
        frame_color = "#f7768e";
        timeout = 0;
      };
    };
  };
}
