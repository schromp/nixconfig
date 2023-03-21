{ config, pkgs, inputs, ... }: {

  services = {
    dbus = {
      packages = with pkgs; [ dconf gcr udisks2 ];
      enable = true;
    };
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    udisks2.enable = true;
    xserver = {
      enable = false;
      displayManager.sddm = {
        enable = false;
        enableHidpi = true;
        settings = {
          General = {
            DisplayServer = "wayland";
          };
        };
      };

      desktopManager.plasma5.enable = false;
    };
    upower.enable = true;

  };

  # add environment variables to the system
  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
  };

  environment.systemPackages = with pkgs; [
    git
    pciutils
    binutils
    coreutils
    moreutils
    curl
    wireplumber
    vim
    gcc
    upower
    htop
    glxinfo
    inputs.eww.packages.x86_64-linux.eww-wayland
  ];

  # for zsh autocompletions on systemlevel
  environment.pathsToLink = [ "/share/zsh" ];


  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  security.pam.services.swaylock = {};

}
