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
  screenshotTool = config.modules.user.screenshotTool;
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
          output = {
            eDP-1 = {
              scale = "1.5";
            };
          };
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
              natural_scroll = "enabled";
              tap = "enabled";
            };
          };
        };
        extraConfig = ''
          bindgesture swipe:right workspace prev
          bindgesture swipe:left workspace next
        '';
      };

      home.packages = with pkgs; [
        brightnessctl # change this to light probably
        wl-clipboard
        swaylock-effects
        swayidle
        libnotify
        xwaylandvideobridge

        slurp
        grim

        (
          if screenshotTool == "grimblast"
          then inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
          else if screenshotTool == "satty"
          then satty
          else if screenshotTool == "swappy"
          then swappy
          else null
        )
      ];
    };
  };
}
