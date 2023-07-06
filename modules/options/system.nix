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
