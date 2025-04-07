{
  inputs,
  pkgs,
  config,
  ...
}: let
  sysConfig = config.modules.system.general;
in {
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
      inherit inputs sysConfig;
    };
  };

  nixpkgs = {
    config.permittedInsecurePackages = [
      "fluffychat-linux-1.23.0"
      "olm-3.2.16"
    ];

    config = {
      allowUnfree = true;
      allowBroken = false;
    };
  };

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    settings = {
      auto-optimise-store = true;

      trusted-users = ["root" "@wheel"];
      builders-use-substitutes = false;

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cosmic.cachix.org/"
        "https://nixpkgs-wayland.cachix.org"
        "https://hyprland.cachix.org"
        "https://anyrun.cachix.org"
        "https://walker.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      ];
    };
  };

  services = {
    dbus = {
      enable = true;
      packages = with pkgs; [dconf gcr udisks2];
    };
    flatpak.enable = true;
  };
  nix.settings.sandbox = true;

  modules.system = {
    general = {
      configPath = "/home/lk/repos/nixconfig";
    };
    programs = {
      greetd.enable = true;
      hyprland = {
        enable = true;
        hyprlock = true;
      };
      cosmic.enable = false;
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
    btop
    git
    curl
    coreutils
    vim
    ranger
    lxqt.lxqt-policykit
    imagemagick
    rnote
    evince
    spotify
    pcmanfm # TODO: configure this or find something better
    vlc
    gimp
    chromium
    proton-pass
    protonvpn-gui
    protonmail-desktop
    bambu-studio
    orca-slicer
    alsa-utils # TODO: why?
    p7zip
    nix-prefetch-git
    freecad
    slack
    pavucontrol
    pa_applet
    powertop
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
    # avahi = {
    #   # Scans for printers on the network
    #   enable = true;
    #   nssmdns4 = true;
    #   openFirewall = true;
    # };
    gvfs.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-mitigate-annoying-profile-switch.conf" ''
            monitor.bluez.properties = {
              bluez5.roles = [ a2dp_sink a2dp_source ]
            }
          '')
        ];
      };
    };
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;
  security.pam.enableSSHAgentAuth = true;

  # TIMEZONE
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  time.hardwareClockInLocalTime = true;

  # FONTS
  fonts = {
    packages = with pkgs; [
      nerd-fonts.hurmit
      nerd-fonts.proggy-clean-tt
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.caskaydia-cove
      nerd-fonts.departure-mono
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
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        amdvlk
      ];
    };
    # pulseaudio.support32Bit = true;
  };

  # Testing https://nixos.wiki/wiki/AMD_GPU
  # systemd.tmpfiles.rules = [
  #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  # ];

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
