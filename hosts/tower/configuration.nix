{
  inputs,
  pkgs,
  ...
}: {

  users.users.root.initialPassword = "1234";
  users.users.lk = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "audio"];
    uid = 1000;
    #shell = pkgs.zsh;
    initialPassword = "1234";
  };

  services = {
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    udisks2.enable = true;
  };

  # for zsh autocompletions on systemlevel
  environment.pathsToLink = ["/share/zsh"];

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  time.hardwareClockInLocalTime = true;

  boot.supportedFilesystems = ["ntfs"];

  networking = {
    networkmanager.enable = true;
    firewall = {
      # this is in here as an example for me
      enable = false;
      allowedTCPPorts = [443 80 22];
    };
  };

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      # despite what the configuration.nix manpage seems to indicate,
      # as of release 17.09, setting device to "nodev" will still call
      # `grub-install` if efiSupport is true
      # (the devices list is not used by the EFI grub install,
      # but must be set to some value in order to pass an assert in grub.nix)
      devices = ["nodev"];
      efiSupport = true;
      enable = true;
      # set $FS_UUID to the UUID of the EFI partition
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root FEB1-D3B7
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  system.stateVersion = "23.11";
}
