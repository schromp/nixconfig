{ inputs, pkgs, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    zip
    unzip
    kitty
    firefox
    cargo
    wofi
    gimp
    pcmanfm
    socat
    jq

    # theme stuff
    bibata-cursors

    # programming stuff
    glfw
    direnv

    python3
  ];
}
