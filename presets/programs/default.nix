{
  config,
  lib,
  ...
}:
with lib; let
in {
  imports = [
    ./hyprland.nix
  ];

  options.presets.programs = mkOption {
    type = types.listOf types.string;
    description = ''
      List the presets you want to include in the configuration here
    '';
  };
}
