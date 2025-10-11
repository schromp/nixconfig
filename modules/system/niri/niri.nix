{
  lib,
  config,
  ...
}: let
  cfg = config.modules.system.programs.niri;
in {
  options.modules.system.programs.niri = {
    enable = lib.mkEnableOption "Enable Niri";
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
  };
}
