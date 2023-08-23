{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  username = import ../../../username.nix;
  cfg = config.modules.desktop;
in {
  options.modules.desktop.swww = {
    enable = mkEnableOption "Enable swww";
  };

  config = mkIf cfg.swww.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [swww];
    };
  };
}
