{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.programs.walker;
in {
  options.modules.home.programs.walker = {
    enable = lib.mkEnableOption "Enable walker";
  };

  imports = [inputs.walker.homeManagerModules.default];

  config = lib.mkIf cfg.enable {
    programs.walker = {
      enable = true;
      runAsService = true;
      config = {
        list = {
          height = 300;
          always_show = false;
          hide_sub = true;
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
          {
            name = "hyprland";
            prefix = "-";
          }
        ];
      };
      # style = builtins.readFile ./style.css;
    };
    # home.packages = [inputs.walker.packages.${pkgs.system}.default];
  };
}
