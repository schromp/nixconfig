{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.installCommon.terminal;
in {
  options.modules.programs.installCommon.terminal = mkEnableOption "Install common terminal packages";

  config = mkIf cfg {
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
        zoxide
      ];
    };
  };
}
