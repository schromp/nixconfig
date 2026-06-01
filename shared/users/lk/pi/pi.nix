{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    pi-coding-agent
    nodejs
  ];

  home.file.".pi".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/pi/pi";
}
