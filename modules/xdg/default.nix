{
  config,
  pkgs,
  lib,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.xdg;

  wm = config.modules.user.desktopEnvironment;
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
  options.modules.programs.xdg = {
    enable = lib.mkEnableOption "Enable xdg options";
    createDirectories = lib.mkEnableOption "Create preset home directories";
    setAssociations = lib.mkEnableOption "Create preset associatons";
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true; # makes programs open with xdg portal
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
        config = {
          common.default = ["gtk"];
          sway.default = lib.mkIf (wm == "sway") ["gtk" "wlr"];
          hyprland.default = lib.mkIf (wm == "hyprland") ["gtk" "hyprland"];
        };

        # config = mkIf cfg.setAssociations {
        #   common = {
        #     default = "*";
        #     "org.freedesktop.impl.portal.Screencast" = "${wm}";
        #     "org.freedesktop.impl.portal.Screenshot" = "${wm}";
        #     "x-scheme-handler/http" = "floorp.desktop";
        #     "x-scheme-handler/https" = "floorp.desktop";
        #   };
        # };
      };
    };

    # This fixes: https://github.com/NixOS/nixpkgs/issues/189851
    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin"
    '';

    home-manager.users.${username} = {
      xdg = {
        userDirs = lib.mkIf cfg.createDirectories {
          enable = true;
          createDirectories = true;
          extraConfig = {
            # Wallpapers = "/home/${username}/Documents/Wallpapers";
          };
        };
        mimeApps = lib.mkIf cfg.setAssociations {
          enable = true;
          defaultApplications = associations;
        };
      };
    };
  };
}
