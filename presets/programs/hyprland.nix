{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.presets.programs;
  appRunner = config.modules.user.appRunner;
in {
  imports = [../../modules];

  config = mkIf (builtins.elem "hyprland" cfg) {
    modules = {
      programs.hyprland.config = {
        # TODO: move the the following into theming
        general = {
          gaps_in = 3;
          gaps_out = 7;
          border_size = 1;
        };

        animations.enabled = false;

        input = {
          sensitivity = "-0.2";
        };

        keybinds = {
          binds =
            [
              # General keys
              {
                key = "Q";
                keyword = "killactive";
              }
              {
                modifier = "$mainMod CONTROL";
                key = "M";
                keyword = "exit";
              }
              {
                key = "V";
                keyword = "togglefloating";
              }
              {
                key = "P";
                keyword = "pseudo";
              }
              {
                key = "F";
                keyword = "fullscreen";
              }
              {
                key = "h";
                keyword = "movefocus";
                command = "l";
              }
              {
                key = "j";
                keyword = "movefocus";
                command = "u";
              }
              {
                key = "k";
                keyword = "movefocus";
                command = "d";
              }
              {
                key = "l";
                keyword = "movefocus";
                command = "r";
              }
              {
                key = "mouse:272";
                keyword = "movewindow";
                mouseBind = true;
              }
              {
                key = "mouse:273";
                keyword = "resizewindow";
                mouseBind = true;
              }

              # Opening programs
              {
                key = "36";
                keyword = "exec";
                command = "kitty";
              }
              {
                key = "B";
                keyword = "exec";
                command = "firefox";
              }
              {
                key = "R";
                keyword = "exec";
                command =
                  if appRunner == "wofi"
                  then "wofi --show drun"
                  else if appRunner == "fuzzel"
                  then "fuzzel"
                  else "";
              }
              {
                modifier = "$mainMod SHIFT";
                key = "S";
                keyword = "exec";
                command = "grimblast copy area";
              }

              # Workspace binds
              # TODO: generate for 10 workspaces
              {
                key = "1";
                keyword = "workspace";
                command = "1";
              }
            ]
            ++ (
              # Generate workspace and movetoworkspace
              builtins.genList (
                x: {
                  key = toString x;
                  keyword = "workspace";
                  command = toString x;
                }
              )
              10
            )
            ++ (
              builtins.genList (
                x: {
                  modifier = "$mainMod SHIFT";
                  key = toString x;
                  keyword = "movetoworkspace";
                  command = toString x;
                }
              )
              10
            );
        };

        workspaces =
          builtins.genList (
            x: {
              default =
                if (x + 1) == 1
                then true
                else false;
              name = toString (x + 1);
            }
          )
          10;

        exec = [
          {command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # screenshare";}
          {command = "wl-paste -p --watch wl-copy -pc # disables middle click paste";}
          (mkIf config.modules.programs.swww.enable {command = "swww init & swww img /home/lk/Pictures/Wallpaper/od_outrun_wave.png";})
          (mkIf config.modules.programs.eww.enable {command = "eww deamon & eww open bar";})
        ];
      };
    };
  };
}
