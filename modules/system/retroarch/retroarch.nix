{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.programs.retroarch;
in {
  options.modules.system.programs.retroarch.enable = lib.mkEnableOption "Enable Retroarch";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      retroarch
      # (retroarch.override {
      #   cores = with libretro; [
      #     genesis-plus-gx
      #     snes9x
      #     beetle-psx-hw
      #     dolphin
      #   ];
      # })
    ];
  };
}
