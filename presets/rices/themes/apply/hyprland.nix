{
  config,
  lib,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.presets.themes;
  colors = cfg.colors;
  cursor = cfg.cursor;
  theme = cfg.theme;
  icon = cfg.icon;

  focused = colors.base0A;
  unfocused = colors.base03;
in {
  config = mkIf (cfg.name != "none") {
    home-manager.users.${username} = {
      wayland.windowManager.hyprland.settings = {
        general = {
          "col.active_border" = "rgb(${focused})";
          "col.inactive_border" = "rgb(${unfocused})";
        };
      };
      gtk = {
        enable = true;

        theme = {
          name = theme.name;
          package = theme.package;
        };

        iconTheme = {
          name = icon.name;
          package = icon.package;
        };

        cursorTheme = {
          name = cursor.name;
          package = cursor.package;
        };
      };
    };
  };
}
