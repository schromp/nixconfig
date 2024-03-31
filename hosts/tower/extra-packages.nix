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
    pantheon.elementary-iconbrowser
    texliveFull

    imagemagick
    rnote
    evince
    okular
    spotify
    discord
    pcmanfm
    helvum
    vlc
    vscodium
    gimp

    inputs.self.packages.${pkgs.system}.affine

    alsa-utils

    audacity
    nwg-look
    qpwgraph

    p7zip
    tshark
    nix-prefetch-git
    
    marp-cli

    xemu
    # rpcs3
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      godot_4
    ];
  };
}
