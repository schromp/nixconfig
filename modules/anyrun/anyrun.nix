{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  opts = config.modules.user;
  username = opts.username;
in {
  home = {
    config = lib.mkIf (opts.appRunner == "anyrun") {
      home-manager.users.${username} = {
        imports = [inputs.anyrun.homeManagerModules.default];

        programs.anyrun = {
          enable = true;
          config = {
            plugins = with inputs.anyrun.packages.${pkgs.system}; [
              applications
              randr
              rink
              shell
              symbols
              translate
            ];
            x = {fraction = 0.5;};
            y = {absolute = 15;};
            width = {fraction = 0.3;};
            hideIcons = false;
            ignoreExclusiveZones = false;
            layer = "overlay";
            hidePluginInfo = false;
            closeOnClick = false;
            showResultsImmediately = false;
            maxEntries = null;
          };

          extraCss = builtins.readFile ./style-dark.css;

          extraConfigFiles."some-plugin.ron".text = ''
            Config(
              // for any other plugin
              // this file will be put in ~/.config/anyrun/some-plugin.ron
              // refer to docs of xdg.configFile for available options
            )
          '';
        };
      };
    };
  };
}
