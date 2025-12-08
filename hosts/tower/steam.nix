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

  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    nexusmods-app
    steamcmd
    gamemode

    prismlauncher
    glfw
    alsa-oss
    openal
  ];
  hardware.xpadneo.enable = true; # Enable controller support
  hardware.steam-hardware.enable = true;
}
