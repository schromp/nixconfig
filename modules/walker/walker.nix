{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  username = config.modules.user.username;
  opts = config.modules.user;
in {
  home = {
    config = lib.mkIf (opts.appRunner == "walker") {
      home-manager.users.${username} = {
        imports = [inputs.walker.homeManagerModules.walker];

        programs.walker = {
          enable = true;
          runAsService = false;
          config = {
            # placeholder = "test123";
            # terminal = "kitty";
            list = {
              height = 500;
            };
            modules = [
              {
                name = "applications";
                prefix = "";
              }
              {
                name = "runner";
                prefix = "$";
              }
              {
                name = "websearch";
                prefix = "?";
              }
              {
                name = "switcher";
                prefix = "/";
              }
              {
                name = "finder";
                prefix = "~";
              }
            ];
          };
          style = builtins.readFile ./style.css;
        };
      };
    };
  };
}
