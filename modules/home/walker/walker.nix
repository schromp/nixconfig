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

  # imports = [inputs.walker.homeManagerModules.default];

  config = lib.mkIf cfg.enable {
    # programs.walker = {
    # enable = true;
    # runAsService = false;
    # config = {
    #   list = {
    #     height = 300;
    #     always_show = false;
    #     hide_sub = true;
    #   };
    #   modules = [
    #     {
    #       name = "applications";
    #       prefix = "";
    #     }
    #     {
    #       name = "runner";
    #       prefix = "$";
    #     }
    #     {
    #       name = "websearch";
    #       prefix = "?";
    #     }
    #     {
    #       name = "switcher";
    #       prefix = "/";
    #     }
    #     {
    #       name = "finder";
    #       prefix = "~";
    #     }
    #     {
    #       name = "hyprland";
    #       prefix = "-";
    #     }
    #   ];
    # };
    # style = builtins.readFile ./style.css;
    # };
    home.packages = [inputs.walker.packages.${pkgs.system}.default];
    nix.settings = {
      substituters = ["https://walker-git.cachix.org"];
      trusted-public-keys = ["walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="];
    };
  };
}
