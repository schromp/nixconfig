{
  config,
  lib,
  options,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.bat;
in {
  options.modules.programs.bat = {
    enable = lib.mkEnableOption "Enable bat";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.bat = {
        enable = true;
      };
    };
  };
}
