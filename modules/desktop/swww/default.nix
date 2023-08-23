{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs;
in {
  options.modules.programs.swww = {
    enable = mkEnableOption "Enable swww";
  };

  config = mkIf cfg.swww.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [swww];
    };
  };
}
