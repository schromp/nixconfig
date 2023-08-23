{lib, ...}:
with lib; let
  cfg = options.modules.desktop.themes;
in {
  cfg.name = mkOption {
    type = types.enum ["WIP"];
    default = "WIP";
    description = ''
      Select the theme to be used.
    '';
    example = "WIP";
  };

  config = let
    createTheme = name: (
      mkIf
      (builtins.elem "WIP" cfg.name)
      {
        modules = [./${name}.nix];
      }
    );
  in
    mkMerge [
      createTheme "WIP"
    ];
}
