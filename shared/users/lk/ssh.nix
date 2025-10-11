{...}: 
{
  programs.ssh = {
        enable = true;
        forwardAgent = true;
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            identityFile = "~/.ssh/github";
          };
          "linode" = {
            hostname = "194.233.162.214";
            identityFile = "~/.ssh/linode";
          };
          "git.uni-due.de" = {
            identityFile = "~/.ssh/gitlab-uni-due";
          };
          "git.ude-syssec.de" = {
            hostname = "git.ude-syssec.de";
            identityFile = "~/.ssh/gitlab-syssec";
          };
          "cloudy" = {
            hostname = "157.180.37.119";
            identityFile = "~/.ssh/hetzner-cloudy";
          };
          "sparrow" = {
            hostname = "192.168.178.2";
            identityFile = "~/.ssh/hetzner-cloudy";
          };
          "quiescent" = {
            user = "root";
            hostname = "192.168.178.3";
            identityFile = "~/.ssh/hetzner-cloudy";
          };
        };
      };
}
