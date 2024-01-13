{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.user.xdg;

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
  options.modules.user.xdg = {
    enable = mkEnableOption "Enable xdg options";
    createDirectories = mkEnableOption "Create preset home directories";
    setAssociations = mkEnableOption "Create preset associatons";
  };

  config = mkIf cfg.enable {
    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true; # makes programs open with xdg portal
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
        config = mkfIf cfg.setAssociations {
          common = {
            default = "*";
            "org.freedesktop.impl.portal.Screencast" = "${wm}";
            "org.freedesktop.impl.portal.Screenshot" = "${wm}";
          };
        };
      };
    };

    home-manager.users.${username} = {
      xdg = {
        userDirs = mkIf cfg.createDirectories {
          enable = true;
          createDirectories = true;
          extraConfig = {
            Wallpapers = "/home/${username}/Documents/Wallpapers";
          };
        };
        mimeApps = mkIf cfg.setAssociations {
          enable = true;
          defaultApplications = associations;
        };
      };
    };
  };
}
