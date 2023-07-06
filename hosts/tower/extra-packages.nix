{ pkgs, config, ... }: let
  username = config.modules.user.username;
in {
  # here you can add packages specific to your setup.
  environment.systemPackages = with pkgs; [
    rofi
    pdfmixtool
    imagemagick
    discord
    rnote
    evince
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [

    ];
  };
}
