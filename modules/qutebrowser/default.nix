{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.user.browser;
in {

  config = mkIf cfg.browser == "qutebrowser" {
    home-manager.users.${username} = {
      programs.qutebrowser = {
        enable = true;
        settings = {
          tabs.position = "left";
          tabs.width = "8%";
        };
      };
    };
  };
}
