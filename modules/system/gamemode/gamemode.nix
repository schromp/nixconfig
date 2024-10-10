{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.system.programs.gamemode;
in {
  options.modules.system.programs.gamemode.enable = lib.mkEnableOption "Enable gamemode";

  config = lib.mkIf cfg.enable {
    programs.gamemode.enable = true;
  };
}
