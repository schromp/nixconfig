{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.retroarch;
in {
  options.modules.programs.retroarch.enable = mkEnableOption "Enable Retroarch";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (retroarch.override {
        cores = with libretro; [
          genesis-plus-gx
          snes9x
          beetle-psx-hw
          dolphin
        ];
      })
    ];
  };
}
