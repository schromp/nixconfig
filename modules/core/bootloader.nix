{ config, pkgs, lib, ... }:
{
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = false;
    efi.efiSysMountPoint = "/boot/efi";

    grub = {
      enable = true;
      useOSProber = true;
      efiSupport = true;
      device = "nodev";
      theme = null;
      backgroundColor = null;
      splashImage = null;
    };
  };
}
