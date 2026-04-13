{ pkgs, ... }:
{
  home.packages = [ (if pkgs.stdenv.hostPlatform.system == "aarch64-darwin" then pkgs.ghostty-bin else pkgs.ghostty) ];

  xdg.configFile."ghostty/config".text = builtins.readFile ./config;
}
