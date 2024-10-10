{
  config,
  lib,
  ...
}: let
  cfg = config.modules.system.programs.gamescope;
in {
  options.modules.system.programs.gamescope.enable = lib.mkEnableOption "Enable Gamescope";

  config = lib.mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
    };
  };
}
