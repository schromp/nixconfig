{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          keyutils
          libkrb5
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libxcursor
          libxi
          libxinerama
          libxscrnsaver
        ];
    };
    protontricks.enable = true;
    # extraCompatPackages = [
    #   inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.proton-ge
    # ];
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    steamcmd
    gamemode

    prismlauncher
    glfw
    alsa-oss
    openal

    deadlock-mod-manager
  ];
  hardware.xpadneo.enable = true; # Enable controller support
  hardware.steam-hardware.enable = true;
}
