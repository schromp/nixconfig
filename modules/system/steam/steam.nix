{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.programs.steam;
in {
  options.modules.system.programs.steam.enable = lib.mkEnableOption "Enable Steam";

  # imports = [inputs.nix-gaming.nixosModules.steamCompat];

  config = lib.mkIf cfg.enable {
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
      protontricks.enable = true;
      # extraCompatPackages = [
      #   inputs.nix-gaming.packages.${pkgs.system}.proton-ge
      # ];
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    environment.systemPackages = with pkgs; [
      mangohud
      nexusmods-app
    ];
    hardware.xpadneo.enable = true; # Enable controller support
  };
}
