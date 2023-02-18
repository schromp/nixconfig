{ inputs, pkgs, config, lib, self, ... }:
{
  config.home.stateVersion = "22.11";
  
  # add my program modules here :)
  imports = [
    ./packages.nix
    ./hyprland
    ./kitty
    ./neovim
    inputs.hyprland.homeManagerModules.default
  ];


}
