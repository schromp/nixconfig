{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.pi-coding-agent
  ];

  home.file.".pi".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.flakePath}/shared/users/lk/pi/pi";
}
