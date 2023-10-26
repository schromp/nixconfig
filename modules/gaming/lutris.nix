{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.lutris;
in {
  options.modules.programs.lutris.enable = mkEnableOption "Enable lutris";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [lutris wineWowPackages.stable winetricks];
  };
}
