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
            name = mkOption {
              type = str;
            };
            resolution = mkOption {
              type = str;
            };
            refreshRate = mkOption {
              type = str;
            };
            scale = mkOption {
              type = str;
            };
            position = mkOption {
              type = str;
            };
            vrr = mkOption {
              type = bool;
              default = false;
            };
          };
        });
    };
  };
}
