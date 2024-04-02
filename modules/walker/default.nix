{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  username = config.modules.user.username;
  opts = config.modules.user;
in {
  config = mkIf (opts.homeManager.enabled && opts.appRunner == "walker") {
    home-manager.users.${username} = {
      imports = [inputs.walker.homeManagerModules.walker];

      programs.walker = {
        enabled = true;
        runAsService = false;
        config = {
          # placeholder = "test123";
          terminal = "kitty";
          list = {
            height = 500;
          };
          modules = [
            {
              name = "runner";
              prefix = "";
            }
            {
              name = "applications";
              prefix = "";
            }
            {
              name = "websearch";
              prefix = "?";
            }
            {
              name = "switcher";
              prefix = "/";
            }
          ];
        };
      };
    };
  };
}
