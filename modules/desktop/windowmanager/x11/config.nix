{ config, lib, ... }: with lib; let
  username = import ../../../username.nix;
  cfg = config.modules.desktop.x11.config;
in {
  options.modules.desktop.x11.config = {
    mouse = mkEnableOption "enable common mouse config";
  };
  
  config = mkIf cfg.mouse {
    services.xserver.libinput = {
      enable = true;
      mouse = {
        # FIX: not working
        accelSpeed = "5";
        accelProfile = "flat";
      };
    };
  };
}
