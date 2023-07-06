{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.themes;
  createTheme = name:
    mkIf (builtins.elem name cfg.name)
    (import ./${name}.nix);
in {
  options.modules.desktop.themes.name = mkOption {
    type = types.enum ["wip"];
    default = "WIP";
    description = ''
      Select the theme to be used.
    '';
    example = "WIP";
  };

  config = mkMerge [
    # (createTheme "wip")
    # mkIf (cfg.name == "wip") ( import ./wip.nix)
  ];
}
