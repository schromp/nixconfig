{
  inputs,
  pkgs,
  config,
  ...
}: let
  username = config.modules.user.username;
in {
  # Setup the user
  users.users.root.initialPassword = "1234";
  users.defaultUserShell = pkgs.zsh;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "audio" "wireshark" ];
    shell = pkgs.zsh;
    initialPassword = "1234";
  };
  environment.shells = with pkgs; [zsh];

  # Setup home-manager options
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
    };

    users.${username}.home.stateVersion = "23.11";
  };

  # start services
  services = {
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    udisks2.enable = true;
  };

  security.polkit.enable = true;

  # Set timezone
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  time.hardwareClockInLocalTime = true;

  # Fonts
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono" "Iosevka" "FiraCode"];})
    ];

    enableDefaultPackages = true;

    # fontconfig = {
    #   defaultFonts = {
    #     monospace = [
    #       "JetBrainsMono Nerd Font"
    #       "Iosevka Term"
    #       "Iosevka Term Nerd Font Complete Mono"
    #       "Iosevka Nerd Font"
    #       "Noto Color Emoji"
    #     ];
    #     sansSerif = ["Lexend" "Noto Color Emoji"];
    #     serif = ["Noto Serif" "Noto Color Emoji"];
    #     emoji = ["Noto Color Emoji"];
    #   };
    # };
  };

  boot.supportedFilesystems = ["ntfs"];

  # Networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      # this is in here as an example for me
      enable = false;
      allowedTCPPorts = [443 80 22];
    };
  };

  # Bootloader stuff
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
