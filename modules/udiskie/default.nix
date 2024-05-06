{ config, lib, ...}: let
  cfg = config.modules.programs.udiskie;
  username = config.modules.user.username;
in {
  options.modules.programs.udiskie = {
    enable = lib.mkEnableOption "Enable udiskie";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      services.udiskie = {
        enable = true;
        automount = true;
        notify = true;
      };
    };
  };
}
