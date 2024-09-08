{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = config.modules.user.username;
  cfg = config.modules.programs.ssh;
in {
  options.modules.programs.ssh = {
    enable = lib.mkEnableOption "Enable ssh";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.ssh = {
        enable = true;
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            identityFile = "~/.ssh/github";
          };
          "linode" = {
            hostname = "194.233.162.214";
            identityFile = "~/.ssh/linode";
          };
          "git.ude-syssec.de" = {
            hostname = "git.ude-syssec.de";
            identityFile = "~/.ssh/gitlab-syssec";
          };
          "194.233.162.214" = {
            identityFile = "~/.ssh/linode";
          };
        };
      };
    };
  };
}
