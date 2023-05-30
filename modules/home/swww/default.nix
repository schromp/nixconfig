{ config, pkgs, lib, ... }:{
  programs.swww = {
    enable = true;
    #extraConfig = builtins.readFile ./kitty.conf;
  };
}
