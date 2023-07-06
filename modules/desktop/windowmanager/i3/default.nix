{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  username = import ../../../../username.nix;
  cfg = config.modules.desktop.x11.i3;
in {
  options.modules.desktop.x11.i3 = {
    enable = mkEnableOption "Enable i3";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;

      windowManager.i3 = {
        enable = true;
      };

      xrandrHeads = [
        {
          monitorConfig = "Option \"Rotate\" \"inverted\"";
          output = "HDMI-0";
        }
        {
          # monitorConfig = "Option \"Rotate\" \"normal\" \"Position\" \"320 0\" "; # WARN: this might break xorg
          monitorConfig = "Option \"Rotate\" \"normal\" "; # WARN: this might break xorg
          output = "DP-4";
          primary = true;
        }
      ];
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    environment.variables = {
      MOZ_ENABLE_WAYLAND = "1";
    };

    home-manager.users.${username} = {
      home.packages = with pkgs; [arandr feh];

      xdg.configFile."i3/config".text = builtins.readFile ./config;

    };
  };
}
