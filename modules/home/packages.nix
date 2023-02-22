{ inputs, pkgs, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    unzip
    kitty
    firefox
    cargo
    lxappearance
    wofi
    gimp
    pcmanfm

    # theme stuff
    bibata-cursors
  ];
}
