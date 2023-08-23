{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop;
in {
  options.modules.desktop.swww = {
    enable = mkEnableOption "Enable swww";
  };

  config = mkIf cfg.swww.enable {
    home.packages = with pkgs; [ swww ];
  };
}
