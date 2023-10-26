{ config, pkgs, ... }: {
  home.username = "lennartkoziollek";
  home.homeDirectory = "/home/lk";

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;
}
