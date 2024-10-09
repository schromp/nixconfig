{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.system.programs.lutris;
in {
  options.modules.system.programs.lutris.enable = lib.mkEnableOption "Enable lutris";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [lutris wineWowPackages.stable winetricks];
  };
}
