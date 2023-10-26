{lib, ...}:
with lib; {
  options.modules.system = {
    # Here we define global system options

    hostname = mkOption {
      type = types.str;
      description = ''
        The hostname of the system. Is also used as network name
      '';
    };

    architecture = mkOption {
      type = types.str;
      description = "The architecture of the system";
      example = "x86_64-linux";
    };

    bluetooth = mkEnableOption "Enable Bluetooth";

    printing = {
      enable = mkEnableOption "Enable printing";
    };

    virtualization = {
      enable = mkEnableOption "Enable Virtualization";
      docker = {
        enable = mkEnableOption "Enable Docker";
      };
    };

    nvidia = mkEnableOption "Enable Nvidia drivers";

    wacom = mkEnableOption "Enalbe Wacom drivers";
  };
}
