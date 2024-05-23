{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  username = config.modules.user.username;
in {
  # here you can add packages specific to your setup.

  environment.systemPackages = with pkgs; [
    imagemagick
    rnote
    evince
    okular
    spotify
    pcmanfm
    vlc
    gimp

    affine

    alsa-utils

    audacity
    nwg-look
    qpwgraph

    p7zip
    nix-prefetch-git

    xemu
    # rpcs3
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      godot_4
    ];
  };
}
