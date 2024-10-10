{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.libreoffice;
in {
  options.modules.programs.libreoffice.enable = lib.mkEnableOption "Enable Libreoffice";

  config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [libreoffice];

      xdg.desktopEntries = {
        libreoffice = {
          name = "Libreoffice";
          genericName = "Office Suite";
          exec = "libreoffice";
          terminal = false;
          categories = ["Office"];
          mimeType = ["application/msword"];
          # https://github.com/LibreOffice/core/blob/master/solenv/inc/mime.types
        };
      };
  };
}
