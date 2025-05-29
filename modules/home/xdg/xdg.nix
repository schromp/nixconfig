{
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.xdg;

  # Corrected browser desktop file name (adjust if using system Firefox)
  browserDesktopFile = "zen-beta.desktop";
  # browserDesktopFile = "firefox.desktop"; # Use this if you're using Nixpkgs/system Firefox

  associations = {
    "x-scheme-handler/http" = browserDesktopFile;
    "x-scheme-handler/https" = browserDesktopFile;
    "x-scheme-handler/ftp" = browserDesktopFile;
    "x-scheme-handler/about" = browserDesktopFile;
    "x-scheme-handler/unknown" = browserDesktopFile;

    "application/pdf" = "org.gnome.Evince.desktop";

    # If you also want to handle local HTML files with the browser
    "text/html" = browserDesktopFile;
  };
in {
  options.modules.home.programs.xdg = {
    enable = lib.mkEnableOption "Enable xdg options";
    createDirectories = lib.mkEnableOption "Create preset home directories";
    setAssociations = lib.mkEnableOption "Create preset associatons";
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      # This is correct for setting the XDG_CACHE_HOME environment variable
      # cacheHome = config.home.homeDirectory + "/.local/cache";

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
