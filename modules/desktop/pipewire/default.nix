{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.pipewire;
in {
  options.modules.desktop.pipewire = {
    enable = mkEnableOption "Enable pipwire";
  };

  config = mkIf cfg.enable {
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
}
