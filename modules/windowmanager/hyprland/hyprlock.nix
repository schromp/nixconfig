{
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.hyprland.hyprlock;
  monitor = config.modules.user.monitor;
in {
  options.modules.programs.hyprland.hyprlock = {
    enable = mkEnableOption "Enable hyprlock";
  };

  config = mkIf cfg.enable {
    security.pam.services.hyprlock = {};

    home-manager.users.${username} = {
      imports = [inputs.hyprlock.homeManagerModules.default];

      programs.hyprlock = {
        enable = true;
        backgrounds = [
          {
            monitor = "${monitor.name}";
            path = "screenshot";
            blur_size = 2;
            blur_passes = 5;
          }
        ];
      };
    };
  };
}
