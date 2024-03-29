{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.steam;
in {
  options.modules.programs.steam.enable = mkEnableOption "Enable Steam";

  imports = [inputs.nix-gaming.nixosModules.steamCompat];

  config = mkIf cfg.enable {

    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            keyutils
            libkrb5
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
          ];
      };
      extraCompatPackages = [
        inputs.nix-gaming.packages.${pkgs.system}.proton-ge
      ];
    };

    environment.systemPackages = with pkgs; [mangohud];
    hardware.xone.enable = true; # Enable controller support
  };
}
