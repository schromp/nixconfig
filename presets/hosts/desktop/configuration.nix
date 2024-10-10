{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../../users/lk
  ];

  # SHELL:
  users.users.root.initialPassword = "1234";

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [zsh];

  # HOMEMANAGER
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
    };
  };

  nix.settings.sandbox = true;

  modules.system = {
    programs = {
      greetd.enable = true;
      hyprland.enable = true;
    };
  };

  # PROGRAMS
  programs = {
    zsh.enable = true;
    nix-ld.enable = true;
    nh = {
      enable = true;
      flake = "/home/lk/repos/nixconfig";
    };
  };

  # PACKAGES
  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
    imagemagick
    rnote
    evince
    spotify
    pcmanfm # TODO: configure this or find something better
    vlc
    gimp
    chromium
    element-desktop-wayland
    proton-pass
    protonvpn-gui
    protonmail-desktop
    bambu-studio
    alsa-utils # TODO: why?
    p7zip
    nix-prefetch-git
    freecad
    slack
  ];

  # SERVICES
  services = {
    udev.packages = [
      pkgs.android-udev-rules
      pkgs.platformio-core.udev
      pkgs.openocd
    ];

    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    udisks2.enable = true;
    printing = {
      enable = true;
    };
    avahi = {
      # Scans for printers on the network
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
    gvfs.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      # audio.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;

  # TIMEZONE
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  time.hardwareClockInLocalTime = true;

  # FONTS
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

  # NETWORKING
  networking = {
    networkmanager.enable = true;
  };

  # HARDWARE
  hardware = {
    bluetooth.enable = true;
    opentabletdriver.enable = true;
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

  # OBS VIRTUAL CAMERA
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  boot.supportedFilesystems = ["ntfs"];
}
