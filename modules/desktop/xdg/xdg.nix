{ config
, lib
, pkgs
, ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs;
in
{
  options.modules.programs.xdg.enable = mkEnableOption "Enable xdg desktop portal options";

  config =
    mkIf cfg.xdg.enable
      {
        environment.systemPackages = with pkgs; [
          xdg-utils
        ];

        xdg = {
          portal = {
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
        };
      };
}
