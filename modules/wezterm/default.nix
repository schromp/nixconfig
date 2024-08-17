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
      home.packages = [ pkgs.wezterm ];
      xdg.configFile."wezterm/wezterm.lua".text = builtins.readFile ./wezterm.lua;
    };
  };
}
