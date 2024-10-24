{
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.xdg;

  browser = "org.mozilla.firefox.desktop";
  associations = {
    "default-web-browser" = "org.mozilla.firefox.desktop";
    "default-url-scheme-handler" = "org.mozilla.firefox.desktop";
    "application/pdf" = "org.gnome.Evince.desktop";
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
  };
in {
  options.modules.home.programs.xdg = {
    enable = lib.mkEnableOption "Enable xdg options";
    createDirectories = lib.mkEnableOption "Create preset home directories";
    setAssociations = lib.mkEnableOption "Create preset associatons";
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      cacheHome = config.home.homeDirectory + "/.local/cache";
      userDirs = lib.mkIf cfg.createDirectories {
        enable = true;
        createDirectories = true;
      };
      mimeApps = lib.mkIf cfg.setAssociations {
        enable = true;
        associations.added = associations;
        defaultApplications = associations;
      };
    };
  };
}
