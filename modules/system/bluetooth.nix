{ config, lib, ... }: with lib; {

  config = mkIf config.modules.system.bluetooth {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}

