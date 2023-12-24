{ config
, lib
, inputs
, ...
}:
with lib; let
  cfg = config.modules.programs.sddm;
in
{
  options.modules.programs.sddm.enable = mkEnableOption "Enable sddm";

  config = mkIf cfg.enable {
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
