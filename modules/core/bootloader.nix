{ config, pkgs, lib, ... }:
{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";

    grub = {
      enable = false;
      useOSProber = true;
      efiSupport = true;
      device = "nodev";
      theme = null;
      backgroundColor = null;
      splashImage = null;
    };
  };
}
