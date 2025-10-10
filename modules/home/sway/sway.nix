{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.programs.sway;
  modifier = "Mod4";
in {
  options.modules.home.programs.sway = {
    enable = lib.mkEnableOption "Enable sway";
  };

  config = lib.mkIf cfg.enable {
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
          # "${modifier}+r" = "exec walker";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+v" = "floating toggle";
          "${modifier}+Shift+s" = ''exec grim -g "$(slurp -o -r -c '#ff0000ff')" - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png'';
          # "${modifier}+r" = "exec ${lib.getExe pkgs.anyrun}";
        };
        input = {
          "*" = {
            accel_profile = "flat";
            pointer_accel = "-0.2";
            # xkb_layout = "us-umlaute";
            natural_scroll = "false";
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

      slurp
      grim

      # TODO:
      # (
      #   if screenshotTool == "grimblast"
      #   then inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      #   else if screenshotTool == "satty"
      #   then satty
      #   else if screenshotTool == "swappy"
      #   then swappy
      #   else null
      # )
    ];
  };
}
