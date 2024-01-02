{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.presets.rices;
in {
  imports = [./themes ./glass.nix ./solid.nix ];

  options.presets.rices = {
    name = mkOption {
      type = types.enum ["none" "glass" "solid"];
      default = "none";
    };

    vertical = mkEnableOption "Should the desktop be vertical";
  };
}
