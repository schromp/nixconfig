{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules.programs.gdm;
in {
  options.modules.programs.gdm.enable = lib.mkEnableOption "Enable gdm";

  system = {
    config = lib.mkIf cfg.enable {
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
  };
}
