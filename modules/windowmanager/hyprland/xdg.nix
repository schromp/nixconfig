{
  pkgs,
  config,
  default,
  ...
}: let
  username = config.modules.user.username;
  wm = config.modules.user.desktopEnvironment;
  browser = config.modules.user.browser;
  associations = {
    "application/pdf" = "org.gnome.Evince.desktop";
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
  };
in {
  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true; # makes programs open with xdg portal
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = "*";
          "org.freedesktop.impl.portal.Screencast" = "${wm}";
          "org.freedesktop.impl.portal.Screenshot" = "${wm}";
        };
      };
    };

    menus.enable = true;
    sounds.enable = false;
  };

  home-manager.users.${username} = {
    xdg = {
      enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = associations;
      };
    };
  };
}
