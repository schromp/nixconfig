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
    texliveFull

    imagemagick
    rnote
    evince
    okular
    spotify
    discord
    pcmanfm
    audacity
    qpwgraph

    inputs.self.packages.${pkgs.system}.affine

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
