{ inputs, pkgs, stablepkgs, config, lib, self, ... }:
{
  config.home.stateVersion = "22.11";
  
  # add my program modules here :)
  imports = [
    ./packages.nix
    ./hyprland
    ./kitty
    ./neovim
    ./zsh
    ./tmux
    ./lf
    ./themes
    ./eww
    ./spotify
    ./fuzzel
    inputs.hyprland.homeManagerModules.default
  ];


}
