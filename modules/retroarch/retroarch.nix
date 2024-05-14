{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.retroarch;
in {
  options.modules.programs.retroarch.enable = lib.mkEnableOption "Enable Retroarch";

  system = {
    config = lib.mkIf cfg.enable {
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
  };
}
