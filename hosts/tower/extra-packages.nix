{
  pkgs,
  config,
  ...
}: let
  username = config.modules.user.username;
in {
  # here you can add packages specific to your setup.
  environment.systemPackages = with pkgs; [
    rofi

    imagemagick
    rnote
    evince
    spotify
    discord
    pcmanfm
    audacity

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
