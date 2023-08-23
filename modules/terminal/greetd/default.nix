{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let 
  cfg = config.modules.programs.greetd;
in {
  options.modules.programs.greetd.enable = mkEnableOption "Enable greetd + tuigreet";

  config = mkIf cfg.enable {
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
