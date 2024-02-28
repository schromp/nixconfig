{ config
, lib
, ...
}:
with lib; let
  cfg = config.presets.rices;
  username = config.modules.user.username;
  vertical = if cfg.vertical then "slidevert" else "slide";
in
{
  imports = [
    ./themes
  ];

  config = mkIf (cfg.name == "onedark") {
    presets.themes.name = "onedark";

    home-manager.users.${username} = {
      wayland.windowManager.hyprland.settings = mkIf (config.modules.user.desktopEnvironment == "hyprland") {
        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 7;
            passes = 3;
            ignore_opacity = true;
          };
          drop_shadow = true;
          shadow_range = 30;
          shadow_render_power = 3;
          "col.shadow" = "00000099";
          animations = {
            animation = [
              "workspaces,1,3,default,${vertical}"
            ];
          };
        };
      };
    };
  };
}
