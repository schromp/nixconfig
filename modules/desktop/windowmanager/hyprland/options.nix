{
  config,
  lib,
  ...
}:
with lib; let
in {
  options.modules.programs.hyprland.config = {
    exec = mkOption {
      default = [];
      type = with types;
        listOf (submodule {
          options = {
            onReload = mkOption {
              type = bool;
              description = "Exec on every reload";
              default = false;
            };
            command = mkOption {
              type = str;
              description = "The command to be executed";
            };
          };
        });
    };

    keybinds = {
      mainMod = mkOption {
        type = types.str;
        default = "SUPER";
      };

      binds = mkOption {
        default = [];
        type = with types;
          listOf (submodule {
            options = {
              modifier = mkOption {
                type = types.str;
                default = "$mainMod";
                example = "$mainMod CONTROL";
              };
              key = mkOption {
                type = types.str;
                default = " ";
              };
              keyword = mkOption {
                type = types.str;
                example = "exec";
                default = " ";
              };
              command = mkOption {
                type = types.str;
                example = "firefox";
                default = " ";
              };
              mouseBind = mkOption {
                type = types.bool;
                example = "true";
                default = false;
                description = "If the bind is a mousebind. Uses bindm instead of bind";
              };
            };
          });
      };
    };

    workspaces = mkOption {
      default = [];
      type = with types;
        listOf (submodule {
          options = {
            name = mkOption {
              type = types.str;
              example = "1";
              default = "";
              description = ''
                Can be all valid workspace identifiers.
                For example "1" or "name:spotify"
              '';
            };
            monitor = mkOption {
              type = str;
              example = "DP-3";
              default = "";
            };
            default = mkEnableOption "Is default workspace for monitor";
            gaps_in = mkOption {
              type = types.int;
              default = 0;
            };
            gaps_out = mkOption {
              type = types.int;
              default = 0;
            };
            border_size = mkOption {
              type = types.int;
              default = 0;
            };
            border = mkEnableOption "Enable Borders";
            rounding = mkEnableOption "Enable rounding";
            decorate = mkEnableOption "Enable window decorations";
          };
        });
    };

    general = {
      gaps_in = mkOption {
        type = types.int;
        default = 0;
      };
      gaps_out = mkOption {
        type = types.int;
        default = 0;
      };
      border_size = mkOption {
        type = types.int;
        default = 1;
      };
      col_active_border = mkOption {
        type = types.str;
        default = "00000000";
        description = "rgba value";
      };
      col_inactive_border = mkOption {
        type = types.str;
        default = "00000000";
        description = "rgba value";
      };
    };

    animations = {
      enabled = mkOption {
        type = types.bool;
        default = true;
      };
      # TODO: add other animation options
    };

    input = {
      sensitivity = mkOption {
        type = types.str;
        default = "0";
        description = "-1.0 - 1.0, 0 means no modification";
      };
      accel_profile = mkOption {
        type = types.enum ["flat" "adaptive"];
        default = "flat";
      };
    };
  };
}
