{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.pipewire;
in {
  options.modules.programs.pipewire = {
    enable = mkEnableOption "Enable pipwire";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services = {
      pipewire = {
        enable = true;
        # audio.enable = true;
        alsa = {
          enable = true;
        #   support32Bit = true;
        };
        wireplumber.enable = true;
        pulse.enable = true;
        # jack.enable = true;
      };
    };
  };
}
