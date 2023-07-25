{ config, lib, pkgs, ... }: with lib; let
  username = config.modules.user.username;
  cfg = config.modules.user.appRunner;
in {
  config = mkIf (cfg == "wofi") {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        wofi
      ];
    };
  };
}
