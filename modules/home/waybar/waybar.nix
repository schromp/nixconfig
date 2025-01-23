{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.programs.waybar;
  terminal-style = import ./terminal.nix {inherit config;};
  modern-style = import ./modern.nix {inherit config;};
in {
  options.modules.home.programs.waybar = {
    enable = lib.mkEnableOption "Enable waybar";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
      style =
        if config.modules.home.general.theme.name == "terminal"
        then terminal-style
        else if config.modules.home.general.theme.name == "modern"
        then modern-style
        else "";

      settings = {
        primary = {
          mode = "dock";
          layer = "top";
          position = "top";

          height = 24;
          spacing = 5;

          modules-left = [
            "hyprland/workspaces"
          ];

          modules-center = [
            "hyprland/window"
          ];

          modules-right = [
            "tray"
            "wireplumber"
            "cpu"
            "memory"
            "privacy"
            "battery"
            "clock"
          ];

          cpu = {
            format = "cpu: {}% ";
          };

          memory = {
            format = "mem: {}% ";
          };

          privacy = {
            icon-size = 10;
          };

          wireplumber = {
            format = "vol: {volume}%";
            format-muted = "vol: muted";
          };

          "hyprland/window" = {
            format = "{}";
            seperate-ouputs = true;
          };

          "hyprland/workspaces" = {
            format = "{icon}";
            on-click = "activate";
            format-icons = {
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
              "7" = "7";
              "8" = "8";
              "9" = "9";
              "10" = "0";
            };
            persistent-workspaces = {
              "*" = 10;
            };
          };
        };
      };
    };
  };
}
