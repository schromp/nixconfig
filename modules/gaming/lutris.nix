{ lib, config, pkgs, ... }: with lib; let
  username = ../../username.nix;
  cfg = config.modules.gaming.lutris;
in {
  
  options.modules.gaming.lutris.enable = mkEnableOption "Enable lutris";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ lutris wineWowPackages.stable winetricks ];
  };

}
