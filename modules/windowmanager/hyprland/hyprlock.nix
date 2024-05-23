{
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.hyprland.hyprlock;
  monitors = config.modules.user.monitors;
in {
  options.modules.programs.hyprland.hyprlock = {
    enable = mkEnableOption "Enable hyprlock";
  };

  config = mkIf cfg.enable {
    security.pam.services.hyprlock = {};

    home-manager.users.${username} = {
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
  };
}
