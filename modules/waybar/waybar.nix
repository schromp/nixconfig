{
  config,
  lib,
  pkgs,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs;
in {
  options.modules.programs.waybar = {
    enable = lib.mkEnableOption "Enable waybar";
  };

  home = {
    config = lib.mkIf cfg.waybar.enable {
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
                "hyprland/workspaces"
              ];

              modules-middle = [
                "hyprland/window"
              ];

              modules-right = [
                "battery"
                "tray"
                "clock"
              ];

              "hyprland/workspaces" = {
                format = "{icon}";
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
  };
}
