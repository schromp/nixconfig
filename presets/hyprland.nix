{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.presets;
in {
  imports = [../modules];

  config = mkIf (builtins.elem "hyprland" cfg) {
    modules = {
      programs.hyprland.config = {
        keybinds = {
          binds = [
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
              command = "wofi --show drun";
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
          ];
        };
      };
    };
  };
}
