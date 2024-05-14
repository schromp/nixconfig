{
  config,
  lib,
  pkgs,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.user.appRunner;
in {
  home = {
    config = lib.mkIf (cfg == "wofi") {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          wofi
        ];
      };
    };
  };
}
