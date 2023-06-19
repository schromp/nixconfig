{ inputs, pkgs, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  
  home.packages = with pkgs; [
    # command line utils
    zip
    unzip
    cargo
    socat
    jq
    lazygit
    udiskie
    bitwarden-cli

    # gui programs
    kitty
    wofi
    gimp
    pcmanfm
    nomacs
    firefox
    pavucontrol
    swww
    #inputs.webcord.packages.${pkgs.system}.default
    webcord-vencord
    parted
    obs-studio
    qt6.full

    # Gaming
    prismlauncher
    lutris
    winePackages.waylandFull
    bottles
    steam

    # theme stuff
    bibata-cursors

    # programming stuff
    glfw
    direnv

    # language servers
    python3
  ];
}
