{ inputs, pkgs, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # command line utils
    zip
    unzip
    cargo
    socat
    jq

    # gui programs
    kitty
    wofi
    gimp
    pcmanfm
    firefox
    pavucontrol
    swww
    prismlauncher
    inputs.webcord.packages.${pkgs.system}.default
    parted

    # theme stuff
    bibata-cursors

    # programming stuff
    glfw
    direnv

    # language servers
    python3
  ];
}
