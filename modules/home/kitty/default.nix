{ config, pkgs, lib, ... }:{
  programs.kitty = {
    enable = true;
    theme = "One Dark";
    extraConfig = builtins.readFile ./kitty.conf;
  };
}
