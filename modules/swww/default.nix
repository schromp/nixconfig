{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = config.modules.user.username;
  cfg = config.modules.programs;
in {
  options.modules.programs.swww = {
    enable = lib.mkEnableOption "Enable swww";
  };

  config = lib.mkIf cfg.swww.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [swww];
    };
  };
}
