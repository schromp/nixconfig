{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  username = import ../../../username.nix;
  cfg = config.modules.terminal.commonPackages;
in {
  options.modules.terminal.commonPackages = mkEnableOption "Install common terminal packages";

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
      ];
    };
  };
}
