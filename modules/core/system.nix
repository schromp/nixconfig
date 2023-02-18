{ config, pkgs, ... }: {

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
      displayManager.sddm.enable = false;
      desktopManager.plasma5.enable = false;
    };
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
    curl
    moreutils
    pipewire
    wireplumber
    vim
    gcc
    upower
  ];

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
}
