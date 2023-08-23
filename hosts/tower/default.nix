{ config, ...}:
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ../shared
  ];

}
