{ inputs
, pkgs
, config
, ...
}:
let
  username = config.modules.user.username;
in
{
  # Setup the user
  users.users.root.initialPassword = "1234";
  users.defaultUserShell = pkgs.zsh;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "wireshark" "docker"];
    shell = pkgs.zsh;
    initialPassword = "1234";
  };
  environment.shells = with pkgs; [ zsh ];
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
      (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" "FiraCode" ]; })
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

  boot.supportedFilesystems = [ "ntfs" ];

  # Networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      # this is in here as an example for me
      enable = false;
      allowedTCPPorts = [ 443 80 22 ];
    };
  };
  programs.nm-applet.enable = true;

  virtualisation.docker.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services = {
    upower.enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    # pulseaudio.support32Bit = true;
  };

  system.stateVersion = "23.11";
}
