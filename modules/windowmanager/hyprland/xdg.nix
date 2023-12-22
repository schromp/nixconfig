{ pkgs, ... }: {
  portal = {
    enable = true;
    wlr.enable = false;
    xdgOpenUsePortal = true; # makes programs open with xdg portal
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
  };

  menus.enable = true;
  sounds.enable = false;

  mime = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };
}
