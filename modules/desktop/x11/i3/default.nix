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

      windowManager.i3.enable = true;

      xrandrHeads = [
        {
          monitorConfig = "Option \"Rotate\" \"inverted\"";
          output = "HDMI-0";
        }
        {
          monitorConfig = "Option \"Rotate\" \"normal\"";
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

    home-manager.users.${username} = {
      home.packages = with pkgs; [arandr feh];

      xsession.windowManager.i3 = {
        enable = true;
        config = let
          modifier = "Mod4";
          ws1 = "1";
          ws2 = "2";
          ws3 = "3";
          ws4 = "4";
          ws5 = "5";
          ws6 = "6";
          ws7 = "7";
          ws8 = "8";
          ws9 = "9";
          ws10 = "10";
        in {
          modifier = modifier;
          keybindings = {
            # Config things
            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+r" = "restart";

            # Starting things
            "${modifier}+q" = "kill";
            "${modifier}+Return" = "exec kitty";
            "${modifier}+b" = "exec firefox";
            "${modifier}+r" = "exec rofi -show drun";

            # Layouts
            "${modifier}+f" = "fullscreen toggle";

            # Movement
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";

            "${modifier}+1" = "workspace ${ws1}";
            "${modifier}+2" = "workspace ${ws2}";
            "${modifier}+3" = "workspace ${ws3}";
            "${modifier}+4" = "workspace ${ws4}";
            "${modifier}+5" = "workspace ${ws5}";
            "${modifier}+6" = "workspace ${ws6}";
            "${modifier}+7" = "workspace ${ws7}";
            "${modifier}+8" = "workspace ${ws8}";
            "${modifier}+9" = "workspace ${ws9}";
            "${modifier}+0" = "workspace ${ws10}";

            "${modifier}+Shift+1" = "move container to workspace ${ws1}; workspace ${ws1}";
            "${modifier}+Shift+2" = "move container to workspace ${ws2}; workspace ${ws2}";
            "${modifier}+Shift+3" = "move container to workspace ${ws3}; workspace ${ws3}";
            "${modifier}+Shift+4" = "move container to workspace ${ws4}; workspace ${ws4}";
            "${modifier}+Shift+5" = "move container to workspace ${ws5}; workspace ${ws5}";
            "${modifier}+Shift+6" = "move container to workspace ${ws6}; workspace ${ws6}";
            "${modifier}+Shift+7" = "move container to workspace ${ws7}; workspace ${ws7}";
            "${modifier}+Shift+8" = "move container to workspace ${ws8}; workspace ${ws8}";
            "${modifier}+Shift+9" = "move container to workspace ${ws9}; workspace ${ws9}";
            "${modifier}+Shift+0" = "move container to workspace ${ws10}; workspace ${ws10}";
          };

          window = {
            border = 0;
            hideEdgeBorders = "smart";
            titlebar = false;
          };

          startup = [
            {
              command = "feh --bg-fill ~/Pictures/Wallpaper/wallpaper.png";
              always = true;
              notification = false;
            }
          ];
        };
      };
    };
  };
}
