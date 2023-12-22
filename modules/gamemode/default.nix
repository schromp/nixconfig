{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.gamemode;
in {
  options.modules.programs.gamemode.enable = mkEnableOption "Enable gamemode";

  config = mkIf cfg.enable {
    programs.gamemode.enable = true;
  };
}
