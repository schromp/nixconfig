{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.ironbar;
in {
  options.modules.home.programs.ironbar = {
    enable = lib.mkEnableOption "Enable ironbar";
  };

  config = lib.mkIf cfg.enable {
    # TODO: autostart swaync with wm
    home.packages = [pkgs.ironbar pkgs.swaynotificationcenter];
  };
}
