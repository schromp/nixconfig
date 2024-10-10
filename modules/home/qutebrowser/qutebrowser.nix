{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.home.progams.qutebrowser;
in {

  options.modules.home.programs.qutebrowser = {
    enable = lib.mkEnableOption "Enable qutebrowser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.python311Packages.adblock];
    programs.qutebrowser = {
      enable = true;
      settings = {
        tabs.position = "left";
        tabs.width = "8%";

        content.blocking = {
          enabled = true;
          method = "auto";
        };
      };
    };
  };
}
