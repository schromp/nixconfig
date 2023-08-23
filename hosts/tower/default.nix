{ config, ...}:
{
  modules = [
    ./hardware-configuration.nix
    ./features.nix
  ];

}
