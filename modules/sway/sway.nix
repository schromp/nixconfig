{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  username = config.modules.user.username;
  enabled = config.modules.user.desktopEnvironment == "sway";
  appRunner = config.modules.user.appRunner;
  screenshotTool = config.modules.user.screenshotTool;
  modifier = "Mod4";
in {
  system = {
    config = lib.mkIf enabled {
      programs.sway.enable = true;

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
            # menu = "walker";
            keybindings = lib.mkOptionDefault {
              "${modifier}+Return" = "exec ${lib.getExe pkgs.kitty}";
              "${modifier}+b" = "exec ${lib.getExe pkgs.firefox}";
              "${modifier}+q" = "kill";
              "${modifier}+r" = "exec walker";
              "${modifier}+f" = "fullscreen toggle";
              "${modifier}+v" = "floating toggle";
              "${modifier}+Shift+s" = ''exec grim -g "$(slurp -o -r -c '#ff0000ff')" - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png'';
            };
            input = {
              "*" = {
                accel_profile = "flat";
                pointer_accel = "-0.2";
                # xkb_layout = "us-german-umlaute";
                natural_scroll = "enabled";
                tap = "enabled";
              };
            };
            focus = {
              followMouse = "no";
            };
          };
          extraConfig = ''
            bindgesture swipe:right workspace prev
            bindgesture swipe:left workspace next
          '';
        };

        services.dunst.enable = true;
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
  };
}
