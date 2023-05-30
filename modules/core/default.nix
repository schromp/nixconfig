{ config, pkgs, ...}: {
  imports = [
    ./system.nix
    ./nix.nix
    ./network.nix
    ./users.nix
    ./nvidia.nix
  ];
}
