{
  lib,
  config,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.user.appRunner;
in {
  home = {
    config = lib.mkIf (cfg == "fuzzel") {
      home-manager.users.${username} = {
        programs.fuzzel = {
          enable = true;
          settings = {
            main.width = 60;
          };
        };
      };
    };
  };
}
