{ nixpkgs, inputs, ...}:
  let username = "lk";
in {
  sys = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ../hosts/tower/hardware-configuration.nix
      ../hosts/tower/configuration.nix
    ];
    specialArgs = {
      inherit inputs;
    };
  };
}
