{
  pkgs,
  config,
  lib,
  ...
}: let
  username = config.modules.user.username;
in {
  # here you can add packages specific to your setup.

  # nixpkgs.config.permittedInsecurePackages = lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";

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
    # obsidian

    alsa-utils

    audacity
    nwg-look
    qpwgraph

    p7zip
    tshark
    nix-prefetch-git

    xemu
    rpcs3
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
    ];
  };
}
