{ pkgs
, lib
, config
, ...
}:
with lib; let
  username = config.modules.user.username;
  cfg.desktop = config.modules.programs.installCommon.desktop;
  cfg.terminal = config.modules.programs.installCommon.terminal;
in
{
  options.modules.programs.installCommon.desktop = mkEnableOption "Install common desktop packages";
  options.modules.programs.installCommon.terminal = mkEnableOption "Install common terminal packages";

  config = mkMerge [
    (mkIf cfg.terminal {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          zip
          unzip
          socat
          jq
          udiskie
          bitwarden-cli
          parted
          btop
        ];
      };
    })

    (mkIf cfg.desktop {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          nomacs
          firefox
          pavucontrol
          obs-studio
          # qt6.full
        ];
      };
    })
  ];
}
