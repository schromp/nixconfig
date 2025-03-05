{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.general.theme;
  colors = config.modules.home.general.theme.colorscheme.colors;
in
  lib.mkIf config.modules.home.programs.hyprland.enable {
    wayland.windowManager.hyprland.settings = lib.mkIf (cfg.name == "this is disabled currently!") {
      decoration = {
        rounding = 10;
        shadow = {
          enabled = true;
          color = "rgb(${colors.base03})";
        };
      };

      general = {
        gaps_in = 8;
        gaps_out = 8;
        border_size = 2;
        layout = "dwindle";

        "col.active_border" = "rgb(${colors.base0D})";
        "col.inactive_border" = "rgb(${colors.base03})";
        # "col.active_border" = "rgb(44475a) rgb(bd93f9) 90deg";
        # "col.inactive_border" = "rgba(44475aaa)";
      };

      exec-once = [
        "${lib.getExe pkgs.swww} img /home/lk/Documents/Wallpapers/wallpaper.png"
        "${lib.getExe pkgs.swaynotificationcenter}"
        "${lib.getExe pkgs.ironbar}"
      ];
    };
  }
