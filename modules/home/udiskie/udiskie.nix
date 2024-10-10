{
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.udiskie;
in {
  options.modules.home.programs.udiskie = {
    enable = lib.mkEnableOption "Enable udiskie";
  };
  # TODO: This shall be moved and reevaluated

  config = lib.mkIf cfg.enable {
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
    };
  };
}
