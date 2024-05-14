{...}: {
  system = {
    imports = [
      ./nvidia.nix
      ./bluetooth.nix
    ];
  };
}
