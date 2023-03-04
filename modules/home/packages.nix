{ inputs, pkgs, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    unzip
    kitty
    firefox
    cargo
    wofi
    gimp
    pcmanfm

    # theme stuff
    bibata-cursors

    # programming stuff
    glfw
    direnv
  ];
}
