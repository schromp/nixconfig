{
  inputs,
  pkgs,
  config,
  ...
}:
let
  sysConfig = config;
in
{
  imports = [
    ../../users/lk

    ./nix.nix
    ./packages.nix
    ./pipewire.nix
  ];

  # SHELL:
  users.users.root.initialPassword = "1234";

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # HOMEMANAGER
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs sysConfig;
    };
  };

  services = {
    dbus = {
      enable = true;
      packages = with pkgs; [
        dconf
        gcr
        udisks2
      ];
    };
    displayManager = {
      enable = true;
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    flatpak.enable = false;
    resolved = {
      enable = true;
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      dnssec = "false";
    };
    netbird = {
      enable = false;
      ui.enable = true;
      clients.echsenclub = {
        ui.enable = true;
        port = 51820;
        config = {
          ManagementURL = {
            Host = "netbird.echsen.club:443";
          };
          AdminURL = {
            Host = "netbird.echsen.club:443";
          };
        };
      };
    };
  };

  modules.local.system = {
    compositor = "niri";
  };

  modules.system = {
    general = {
      configPath = "/home/lk/repos/nixconfig";
    };
    programs = {
      hyprland = {
        enable = true;
      };
    };
  };

  # PROGRAMS
  programs = {
    dconf.enable = true;
    zsh.enable = true;
    nix-ld.enable = true;
    nh = {
      enable = true;
      flake = "/home/lk/repos/nixconfig";
    };
  };

  # PACKAGES

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
      nssmdns4 = true;
      openFirewall = true;
    };
    gvfs.enable = true;
    blueman.enable = true;
  };

  security.polkit.enable = true;

  security.rtkit.enable = true;
  security.pam.sshAgentAuth.enable = true;

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
  };

  # NETWORKING
  networking = {
    networkmanager.enable = true;
  };

  # HARDWARE
  hardware = {
    bluetooth = {
      enable = true;
    };
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

  virtualisation.docker.enable = true;

  # OBS VIRTUAL CAMERA
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  boot.supportedFilesystems = [ "ntfs" ];
}
