{
  config,
  lib,
  ...
}: let
  cfg = config.modules.programs.onedrive;
in{
  options.modules.programs.onedrive = {
    enable = lib.mkEnableOption "Enable onedrive";
  };

  config = lib.mkIf cfg.enable {
    services.onedrive.enable = true;
  };
}
