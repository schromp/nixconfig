{
  lib,
  ...
}:
with lib; {
  imports = [
    ./apply

    ./wip.nix
  ];

  # GOAL: have these options for creating themes
  # When selecting theme: options.themes.select = ["name"];
  options.presets.themes = {
    name = mkOption {
      type = types.enum ["none" "wip"];
      description = "The theme that should be applied to programs specified in apply";
      default = "none";
    };

    kind = mkOption {
      type = types.enum ["dark" "light"];
      description = "True if the theme is a darktheme";
    };

    # FIX:
    colors = mkOption {
      type = with types; attrsOf str;
    };
  };
}
