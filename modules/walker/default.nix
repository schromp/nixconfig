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

    nix.settings = {
      substituters = ["https://walker.cachix.org"];
      trusted-public-keys = ["walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="];
    };

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
}
