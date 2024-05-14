{
  lib,
  config,
  pkgs,
  ...
}: let
  username = config.user.username;
  cfg = config.modules.terminal.vifm;
in {
  options.modules.terminal.vifm = {
    enable = lib.mkEnableOption "Enable vifm";
  };

  system = {
    config = lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [vifm];

      # TODO:
      home-manager.users.${username} = {
        xdg.configFile."vifm".text = ''

        '';
      };
    };
  };
}
