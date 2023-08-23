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

  config = mkIf (cfg.name == "glass") {
    presets.themes.name = "catppuccin-latte";

    home-manager.users.${username} = {
      wayland.windowManager.hyprland.settings =
        mkIf (config.modules.user.desktopEnvironment == "hyprland") {
          decoration = {
            rounding = 5;
            multisample_edges = true;
            blur = true;
            blur_size = 5;
            blur_passes = 5;
            blur_ignore_opacity = true;
            drop_shadow = true;
            shadow_range = 30;
            shadow_render_power = 3;
            "col.shadow" = "00000099";
          };
        };
    };
  };
}
