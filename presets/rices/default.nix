{
  config,
  lib,
  ...
}:
let
  cfg = config.presets.rices;
in with lib; {
  imports = [./themes ./glass.nix ./solid.nix ./onedark.nix];

  options.presets.rices = {
    name = mkOption {
      type = types.enum ["none" "glass" "solid" "onedark"];
      default = "none";
    };

    vertical = mkEnableOption "Should the desktop be vertical";
  };
}
