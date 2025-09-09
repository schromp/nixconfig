{
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.general.theme;
  colors = config.modules.home.general.theme;
in
  lib.mkIf config.modules.home.programs.hyprland.enable {
    # modules.home.programs.waybar.enable = true;
    wayland.windowManager.hyprland.settings = lib.mkIf (cfg.name == "terminal") {
      decoration = {
        rounding = 0;
      };

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;
        layout = "dwindle";

        "col.active_border" = "rgb(${colors.base0D})";
        "col.inactive_border" = "rgb(${colors.base03})";
      };

      animations = {
        enabled = false;
      };

      exec-once = [
        "waybar"
        "swww img ~/Pictures/Wallpaper/black.jpg"
      ];
    };
  }
