{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules.system.programs.gdm;
in {
  options.modules.system.programs.gdm.enable = lib.mkEnableOption "Enable gdm";

  config = lib.mkIf cfg.enable {
    services.displayManager = {
      enable = true;
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };
}
