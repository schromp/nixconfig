{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.presets.themes;
in {
  config = mkIf (cfg.name == "wip") {
    presets.themes = {
      kind = "light";
      colors = {
        base00 = "000000";
        base0A = "0089b4";
        base03 = "654321";
      };
    };
  };
}
