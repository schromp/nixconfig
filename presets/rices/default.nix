{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.presets.rices;
in {
  imports = [./themes ./glass.nix];

  options.presets.rices = {
    name = mkOption {
      type = types.enum ["none" "glass"];
      default = "none";
    };
  };
}
