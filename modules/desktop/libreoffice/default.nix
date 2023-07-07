{ config, lib, pkgs, ... }: with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.libreoffice;
in {

  options.modules.programs.libreoffice.enable = mkEnableOption "Enable Libreoffice";

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [ libreoffice ];

      xdg.desktopEntries = {
        libreoffice = {
          name = "Libreoffice";
          genericName = "Office Suite";
          exec = "libreoffice";
          terminal = false;
          categories = [ "Office" ];
          mimeType = [ "application/msword" ];
          # https://github.com/LibreOffice/core/blob/master/solenv/inc/mime.types
        };
      };
    };
  };

}
