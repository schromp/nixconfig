{
  inputs,
  config,
  lib,
  ...
}:
let
  username = config.modules.user.username;
  cfg = config.modules.programs.hyprland.hyprlock;
  monitors = config.modules.user.monitors;
in {
  options.modules.programs.hyprland.hyprlock = {
    enable = lib.mkEnableOption "Enable hyprlock";
  };

  config = lib.mkIf cfg.enable {
    security.pam.services.hyprlock = {};

    home-manager.users.${username} = {
      # imports = [inputs.hyprlock.homeManagerModules.default];
      #
      # programs.hyprlock = {
      #   enable = true;
      #   backgrounds = [
      #     {
      #       # monitor = "${(lists.take 1 monitors).name}"; TODO:
      #       path = "screenshot";
      #       blur_size = 2;
      #       blur_passes = 5;
      #     }
      #   ];
      # };
    };
  };
}
