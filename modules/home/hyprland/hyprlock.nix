{
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.home.programs.hyprland.hyprlock;
in {
  options.modules.home.programs.hyprland.hyprlock = {
    enable = mkEnableOption "Enable hyprlock";
  };

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        backgrounds = [
          {
            # monitor = "${(lists.take 1 monitors).name}"; TODO:
            path = "screenshot";
            blur_size = 2;
            blur_passes = 5;
          }
        ];
      };
    };
  };
}
