{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.system.programs.gdm;
in {
  options.modules.programs.gdm.enable = mkEnableOption "Enable gdm";

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    };
  };
}
