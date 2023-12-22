{ config
, lib
, pkgs
, ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.ssh;
in
{
  options.modules.programs.ssh = {
    enable = mkEnableOption "Enable ssh";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.ssh = {
        enable = true;
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            identityFile = "~/.ssh/github";
          };
        };
      };
    };
  };
}
