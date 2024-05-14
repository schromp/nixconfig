{
  lib,
  config,
  pkgs,
  ...
}: let
  username = config.modules.user.username;
  cfg.desktop = config.modules.programs.installCommon.desktop;
  cfg.terminal = config.modules.programs.installCommon.terminal;
in {
  system = {
    options.modules.programs.installCommon.desktop = lib.mkEnableOption "Install common desktop packages";
    options.modules.programs.installCommon.terminal = lib.mkEnableOption "Install common terminal packages";

    config = lib.mkMerge [
      (lib.mkIf cfg.terminal {
        home-manager.users.${username} = {
          home.packages = with pkgs; [
            zip
            unzip
            socat
            jq
            bitwarden-cli
            parted
            htop
            btop
            tldr
          ];
        };
      })

      (lib.mkIf cfg.desktop {
        home-manager.users.${username} = {
          home.packages = with pkgs; [
            nomacs
            firefox
            pavucontrol
            obs-studio
            # qt6.full
            slack
          ];
        };
      })
    ];
  };
}
