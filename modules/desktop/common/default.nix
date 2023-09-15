{pkgs, lib, config, ...}: with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.installCommon.desktop;
in {
  options.modules.programs.installCommon.desktop = mkEnableOption "Install common desktop packages";

  config = mkIf cfg {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        nomacs
        firefox
        pavucontrol
        obs-studio
        # qt6.full
      ];
    };
  };
}
