{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.themer;
  username = config.modules.user.username;
in {
  options = {
    modules.programs.themer = {
      enable = lib.mkEnableOption "Enable themer";
    };
  };

  home = {
    config = lib.mkIf cfg.enable {
      home-manager.users.${username} = {
        home.packages = [
          inputs.themer.packages.${pkgs.system}.default
        ];
        xdg.configFile = {
          "themer/gruvbox.yaml".source = ./gruvbox.yaml;
          "themer/catppuccin.yaml".source = ./catppuccin.yaml;
          "themer/onedark.yaml".source = ./onedark.yaml;
          "themer/rose-pine-dawn.yaml".source = ./rose-pine-dawn.yaml;
          "themer/rose-pine-moon.yaml".source = ./rose-pine-moon.yaml;
        };
      };
    };
  };
}
