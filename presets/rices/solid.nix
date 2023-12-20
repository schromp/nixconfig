{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.presets.rices;
  username = config.modules.user.username;
in {
  imports = [
    ./themes
  ];

  config = mkIf (cfg.name == "solid") {
    presets.themes.name = "catppuccin-mocha";

    home-manager.users.${username} = {
      wayland.windowManager.hyprland.settings = mkIf (config.modules.user.desktopEnvironment == "hyprland") {
        decoration = {
          rounding = 5;
          blur = {
            enabled = false;
            size = 5;
            passes = 5;
            ignore_opacity = true;
          };
          drop_shadow = true;
          shadow_range = 30;
          shadow_render_power = 3;
          "col.shadow" = "00000099";
        };
      };
    };
  };
}
