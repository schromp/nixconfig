{
  config,
  pkgs,
  lib,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.user.browser;
in {
  home = {
    config = lib.mkIf (cfg == "qutebrowser") {
      home-manager.users.${username} = {
        home.packages = [pkgs.python311Packages.adblock];
        programs.qutebrowser = {
          enable = true;
          settings = {
            tabs.position = "left";
            tabs.width = "8%";

            content.blocking = {
              enabled = true;
              method = "auto";
            };
          };
        };
      };
    };
  };
}
