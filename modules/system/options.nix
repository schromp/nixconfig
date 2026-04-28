{lib, ...}: {
  options.modules.local.system = {
    compositor = lib.mkOption {
      type = lib.types.enum [ "hyprland" "niri" "cosmic" "none" ];
      default = "none";
    };
  };

  options.modules.system.general = {
    # Here we define global system options

    configPath = lib.mkOption {
      type = lib.types.str;
    };

    homeManager = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Enable home-manager on this system
      '';
    };

    nvidia = lib.mkEnableOption "Enable Nvidia drivers";

    monitors = lib.mkOption {
      type = with lib.types;
        listOf (submodule {
          options = {
            name = lib.mkOption {
              type = str;
            };
            resolution = lib.mkOption {
              type = str;
            };
            refreshRate = lib.mkOption {
              type = str;
            };
            scale = lib.mkOption {
              type = str;
            };
            position = lib.mkOption {
              type = str;
            };
            vrr = lib.mkOption {
              type = bool;
              default = false;
            };
            transform = lib.mkOption {
              type = str;
              default = "";
            };
          };
        });
    };

  };
}
