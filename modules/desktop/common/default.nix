{pkgs, lib, config, ...}: with lib; let
  username = import ../../../username.nix;
  cfg = config.modules.desktop.commonPackages;
in {
  options.modules.desktop.commonPackages = mkEnableOption "Install common desktop packages";

  config = mkIf cfg {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        wofi
        pcmanfm
        nomacs
        firefox
        pavucontrol
        webcord-vencord
        obs-studio
        qt6.full
      ];
    };
  };
}
