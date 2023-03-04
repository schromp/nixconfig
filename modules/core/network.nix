{ config, pkgs, ... }:
{
  networking = {
    networkmanager.enable = true;
    firewall = {
      # this is in here as an example for me
      enable = false;
      allowedTCPPorts = [ 443 80 22 ];
    };
    wireless = {
      enable = false;
      userControlled.enable = true;
      networks = {
        # all of the network stuff is case sensetive!
        "Groovy".pskRaw = "fcd9d426518e93f0a0bcdb0a9b527e3332bea2e43c0dcdfe56ce75927d1c9e99";

        # To generate pskRaw: wpa_passphrase SSID password
        # Example Uni network
        # "uwf-argo-air" = {
        #   hidden = true;
        #   auth = ''
        #     key_mgmt=WPA-EAP
        #     eap=PEAP
        #     phase2="auth=MSCHAPV2"
        #     identity="unx42"
        #     password="p@$$w0rd"
        #   '';
        # };
      };
    };
  };

  # Someone said disabling this speeds up boot times
  # systemd.services.NetworkManager-wait-online.enable = false;
}
