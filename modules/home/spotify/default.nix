{ config, pkgs, inputs, ... }: {
  
  services.spotifyd.enable = true;

  home.packages = with pkgs; [ spotify-tui ];


}

