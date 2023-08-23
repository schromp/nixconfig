{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.steam;
in {
  options.modules.programs.steam.enable = mkEnableOption "Enable Steam";

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    # environment.systemPackages = with pkgs; [ steam ];
  };
}
