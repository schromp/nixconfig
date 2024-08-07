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
    extraGroups = ["wheel" "networkmanager" "audio" "wireshark" "docker"];
    shell = pkgs.zsh;
    initialPassword = "1234";
  };
  environment.shells = with pkgs; [zsh];
  programs.zsh.enable = true;

  # Setup home-manager options
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
    };

    users.${username}.home.stateVersion = "23.11";
  };

  nix.settings.sandbox = true;

  # start services
  services = {
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    udisks2.enable = true;
    printing = {
      enable = true;
    };
    avahi = { # Scans for printers on the network
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
  };

  # This is for obs virtual camera
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  security.polkit.enable = true;
  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
  ];

  # Set timezone
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  time.hardwareClockInLocalTime = true;

  # Fonts
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "Iosevka"
          "FiraCode"
          "Hermit"
          "ProggyClean"
          # "Cascadia Code"
        ];
      })
      hack-font
      # CaskaydiaCove
      cascadia-code
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

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        amdvlk
      ];
    };
    # pulseaudio.support32Bit = true;
  };

  # Testing https://nixos.wiki/wiki/AMD_GPU
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  virtualisation.docker.enable = true;

  # Bootloader stuff
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/nvme0n1";
      useOSProber = true;
    };
  };

  system.stateVersion = "23.11";
}
