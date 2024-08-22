{
  config,
  options,
  lib,
  pkgs,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.wezterm;
in {
  options.modules.programs.wezterm = {
    enable = lib.mkEnableOption "Enable Wezterm";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {

      programs.wezterm = {
        enable = true;
        extraConfig = ''
          local config = require "extras"
          return config
        '';
        enableZshIntegration = true;
      };

      xdg.configFile."wezterm/extras.lua".text = builtins.readFile ./wezterm.lua;
    };
  };
}
