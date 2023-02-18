{ config, pkgs, ... }:
{
  networking = {
    networkmanager.enable = true;
    firewall = {
      # this is in here as an example for me
      enable = false;
      allowedTCPPorts = [ 443 80 22 ];
    };
  };

  # Someone said disabling this speeds up boot times
  systemd.services.NetworkManager-wait-online.enable = false;
}
