{
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.wezterm;
in {
  options.modules.home.programs.wezterm = {
    enable = lib.mkEnableOption "Enable Wezterm";
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      # extraConfig = ''
      #   local config = require "extras"
      #   return config
      # '';
      # enableZshIntegration = false;
    };

    # xdg.configFile."wezterm/extras.lua".text = builtins.readFile ./wezterm.lua;
  };
}
