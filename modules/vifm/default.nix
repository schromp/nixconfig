{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  username = config.user.username;
  cfg = config.modules.terminal.vifm;
in {
  options.modules.terminal.vifm = {
    enable = mkEnableOption "Enable vifm";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [vifm];

    # TODO:
    home-manager.users.${username} = {
      xdg.configFile."vifm".text = ''

      '';
    };
  };
}
