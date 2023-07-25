{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.presets.themes;
  colors = cfg.colors;

  focused = colors.base0A;
  unfocused = colors.base03;
in {
  imports = [../../../modules];

  config =
    mkIf (cfg.name != "none") {
      modules.programs.hyprland.config.general = {
        # FIX: Hardcoded transparency values
        col_active_border = "${focused}fa";
        col_inactive_border = "${unfocused}aa";
      };
    };
}
