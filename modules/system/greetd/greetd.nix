{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.programs.greetd;
in {
  options.modules.system.programs.greetd.enable = lib.mkEnableOption "Enable greetd + tuigreet";

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
  };
}
