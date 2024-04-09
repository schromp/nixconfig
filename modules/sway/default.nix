{
  inputs,
  config,
  lib,
  pkgs,
  options,
  ...
}:
with lib; let
  username = config.modules.user.username;
  enabled = config.modules.user.desktopEnvironment == "sway";
  appRunner = config.modules.user.appRunner;
  modifier = "Mod4";
in {
  config = mkIf enabled {
    home-manager.users.${username} = {
      wayland.windowManager.sway = {
        enable = true;
        xwayland = true;
        wrapperFeatures = {
          base = true;
          gtk = true;
        };
        systemd.enable = true;
        config = {
          # output = {
          # };
          modifier = "${modifier}";
          menu = "walker";
          keybindings = lib.mkOptionDefault {
            "${modifier}+Return" = "exec ${lib.getExe pkgs.kitty}";
            "${modifier}+b" = "exec ${lib.getExe pkgs.firefox}";
            "${modifier}+q" = "kill";
            "${modifier}+r" = "exec walker";
            "${modifier}+f" = "fullscreen toggle";
          };
          input = {
            "*" = {
              accel_profile = "flat";
              pointer_accel = "0.3";
              xkb_layout = "us-german-umlaut";
            };
          };
        };
      };
    };
  };
}
