{...}: {

  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./features.nix
    # ../shared
    # ./extra-packages.nix
  ];
}
