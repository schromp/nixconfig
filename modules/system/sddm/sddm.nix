{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules.system.programs.sddm;
in {
  options.modules.system.programs.sddm.enable = lib.mkEnableOption "Enable sddm";

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
}
