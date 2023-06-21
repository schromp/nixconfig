{nixpkgs, self, ...}:
let
  inputs = self.inputs;
in {
  testing = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ../hosts/tower/hardware-configuration.nix
      ../hosts/tower/configuration.nix
      {
        imports = [ ./testing.nix ];
        #config.modules.desktop.hyprland.enable = true;
        #config.username = "lk"; # FIX: this does not work
      }
    ];
    specialArgs = { inherit inputs; };
  };
}
