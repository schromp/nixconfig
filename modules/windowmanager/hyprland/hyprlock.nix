{
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.hyprland.hyprlock;
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
      };
    };
  };
}
