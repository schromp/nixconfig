{ config, nixpkgs, ... }: {
  home = {
    username = "lk";
    homeDirectory = "/home/lk";

    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
}
