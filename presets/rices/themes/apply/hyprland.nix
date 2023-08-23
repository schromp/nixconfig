{
  config,
  lib,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.presets.themes;
  colors = cfg.colors;

  focused = colors.base0A;
  unfocused = colors.base03;
in {
  config = mkIf (cfg.name != "none") {
    home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
      general = {
        # FIX: Hardcoded transparency values
        "col.active_border" = "rgb(${focused})";
        "col.inactive_border" = "rgb(${unfocused})";
      };
    };
  };
}
