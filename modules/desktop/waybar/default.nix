{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs;
in {
  options.modules.programs.waybar = {
    enable = mkEnableOption "Enable waybar";
  };

  config = mkIf cfg.waybar.enable {
    home-manager.users.${username} = {
      programs.waybar = {
        enable = true;
        package = pkgs.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
        });
        systemd.enable = true;
        settings = {
          primary = {
            mode = "dock";
            layer = "top";
            position = "top";

            height = 30;

            modules-left = [
              "wlr/workspaces"
            ];

            modules-middle = [
              "hyprland/window"
            ];

            modules-right = [
              "battery"
              "tray"
              "clock"
            ];

            "wlr/workspaces" = {
              format = "{icon}";
              on-scroll-up = "hyprctl dispatch workspace e+1";
              on-scroll-down = "hyprctl dispatch workspace e-1";
              on-click = "activate";
              format-icons = {
                active = "";
                default = "";
                urgent = "";
              };
            };
          };
        };
      };
    };
  };
}
