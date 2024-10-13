{lib, ...}: {
  options.modules.system.general = {
    # Here we define global system options

    hostname = lib.mkOption {
      type = lib.types.str;
      description = ''
        The hostname of the system. Is also used as network name
      '';
    };

    homeManager = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Enable home-manager on this system
      '';
    };

    architecture = lib.mkOption {
      type = lib.types.str;
      description = "The architecture of the system";
      example = "x86_64-linux";
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
          };
        });
    };

    keymap = lib.mkOption {
      type = lib.types.enum ["us-umlaute"];
    };
  };
}
