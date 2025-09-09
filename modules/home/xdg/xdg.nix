{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.home.programs.xdg;
  defaults = config.modules.home.general.desktop;

  browserDesktopFile =
    if defaults.defaultBrowser == "zen"
    then "zen-beta.desktop"
    else "firefox.desktop";
  imageDesktopFile = "org.gnome.Loupe.desktop";

  associations = {
    "x-scheme-handler/http" = browserDesktopFile;
    "x-scheme-handler/https" = browserDesktopFile;
    "x-scheme-handler/ftp" = browserDesktopFile;
    "x-scheme-handler/about" = browserDesktopFile;
    "x-scheme-handler/unknown" = browserDesktopFile;

    "application/pdf" = "org.gnome.Evince.desktop";

    "image/png" = imageDesktopFile;
    "image/gif" = imageDesktopFile;
    "image/bmp" = imageDesktopFile;
    "image/webp" = imageDesktopFile;
    "image/tiff" = imageDesktopFile;

    # If you also want to handle local HTML files with the browser
    "text/html" = browserDesktopFile;

    "inode/directory" = "org.gnome.Nautilus.desktop";
    "inode/mount-point" = "org.gnome.Nautilus.desktop";
  };
in {
  options.modules.home.programs.xdg = {
    enable = lib.mkEnableOption "Enable xdg options";
    createDirectories = lib.mkEnableOption "Create preset home directories";
    setAssociations = lib.mkEnableOption "Create preset associatons";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [xdg-utils];
    xdg = {
      userDirs = lib.mkIf cfg.createDirectories {
        enable = true;
        createDirectories = true;
      };

      mimeApps = lib.mkIf cfg.setAssociations {
        enable = true;
        defaultApplications = associations;
      };
    };
  };
}
