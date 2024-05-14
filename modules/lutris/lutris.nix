{
  lib,
  config,
  pkgs,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.lutris;
in {
  options.modules.programs.lutris.enable = lib.mkEnableOption "Enable lutris";

  system = {
    config = lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [lutris wineWowPackages.stable winetricks];
    };
  };
}
