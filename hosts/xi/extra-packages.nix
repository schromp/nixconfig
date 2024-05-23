{
  pkgs,
  config,
  inputs,
  ...
}: let
  username = config.modules.user.username;
in {
  # here you can add packages specific to your setup.
  environment.systemPackages = with pkgs; [
    pantheon.elementary-iconbrowser

    imagemagick
    rnote
    evince
    okular
    spotify
    discord
    pcmanfm
    audacity
    qpwgraph

    zoom-us
    slack

    affine

    p7zip
    tshark
    nix-prefetch-git

    xemu
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
    ];
  };
}
