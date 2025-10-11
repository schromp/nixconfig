{ pkgs, ... }:
{
  home.packages = [ pkgs.python311Packages.adblock ];
  programs.qutebrowser = {
    enable = true;
    settings = {
      tabs.position = "left";
      tabs.width = "8%";

      content.blocking = {
        enabled = true;
        method = "auto";
      };
    };
  };
}
