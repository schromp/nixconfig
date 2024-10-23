{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.general.theme;
in {
  wayland.windowManager.hyprland.settings = lib.mkIf (cfg == "dracula") {
    decoration = {
      rounding = 10;
      "col.shadow" = "rgba(1E202966)";
    };

    general = {
      gaps_in = 8;
      gaps_out = 8;
      border_size = 2;
      layout = "dwindle";

      "col.active_border" = "rgb(44475a) rgb(bd93f9) 90deg";
      "col.inactive_border" = "rgba(44475aaa)";
    };

    exec-once = [
      "${lib.getExe pkgs.swww} img /home/lk/Documents/Wallpapers/wallpaper.png"
      "${lib.getExe inputs.hyprpanel.packages.${pkgs.system}.default}"
    ];
  };
}
