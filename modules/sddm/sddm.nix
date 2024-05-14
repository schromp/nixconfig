{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules.programs.sddm;
in {
  options.modules.programs.sddm.enable = lib.mkEnableOption "Enable sddm";

  system = {
    config = lib.mkIf cfg.enable {
      services.xserver = {
        enable = true;
        displayManager = {
          sddm = {
            enable = true;
            wayland.enable = true;
            settings = {
              #General = {
              #  DisplayServer = "x11";
              #};
            };
          };

          session = [
            {
              manage = "window";
              name = "hyprland";
              start = ''
                Hyprland &
              '';
            }
          ];
        };
      };
    };
  };
}
