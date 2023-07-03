{ config, lib, ... }: with lib; let
  cfg = config.modules.desktop.displaymanager.sddm;
in {
  options.modules.desktop.displaymanager.sddm.enable = mkEnableOption "Enable sddm";

  config = mkIf cfg.enable {
    
      displayManager = {
        sddm = {
          enable = true;
        };
      };
  };
}
