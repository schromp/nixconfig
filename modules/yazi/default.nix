{
  config,
  options,
  pkgs,
  lib,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.yazi;
in {
  options.modules.programs.yazi = {
    enable = lib.mkEnableOption "Enable Yazi terminal file manager";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
