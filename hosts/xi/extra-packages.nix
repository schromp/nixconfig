{
  pkgs,
  config,
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
    audacity
    soundux

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
