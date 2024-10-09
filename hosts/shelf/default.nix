{...}: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    # Users
    ../../users/lks/default.nix
  ];
}
