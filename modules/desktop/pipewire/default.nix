{ lib, ... }:
with lib; let
  cfg = options.modules.desktop.pipewire;
in {
  
  cfg = {
    enable = mkEnableOption "Enable pipwire";
  };

  config = {
    pipwire = mkIf cfg.enable {
      services = {
        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          wireplumber.enable = true;
          pulse.enable = true;
          # jack.enable = true;
        };
      };
    };
  };
}
