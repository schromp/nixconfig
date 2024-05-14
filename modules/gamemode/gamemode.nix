{
  config,
  lib,
  pkgs,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.gamemode;
in {
  system = {
    options.modules.programs.gamemode.enable = lib.mkEnableOption "Enable gamemode";

    config = lib.mkIf cfg.enable {
      programs.gamemode.enable = true;
    };
  };
}
