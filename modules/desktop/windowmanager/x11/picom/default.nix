{ config, lib, pkgs, ...}: with lib; let 
  username = ../../../../username.nix;
  cfg = config.modules.desktop.x11.picom;
in {
  options.modules.desktop.x11.picom.enable = mkEnableOption "Enable picom";

  config = mkIf cfg.enable {
    
    services.picom = {
      enable = true;
      # activeOpacity = 8.0;
      # backend = "glx";
    };  

  };
}
