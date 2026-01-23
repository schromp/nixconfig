{ pkgs, ... }:
{
  home.packages = [ (if pkgs.system == "aarch64-darwin" then pkgs.ghostty-bin else pkgs.ghostty) ];

  xdg.configFile."ghostty/config".text = builtins.readFile ./config;
}
