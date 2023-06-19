{
  config,
  lib,
  ...
}: with lib; let
  cfg = config.modules.desktop;
in {
  options.modules.desktop.swww = {
    enable = mkEnableOption "Enable swww";
  };

  config.enable = mkIf cfg.swww.enable {
    programs.swww.enable = true;
  };
}
