{
  nixpkgs,
  inputs,
  home-manager,
  nix-darwin,
  ...
}: let
  mkNixosSystem = hostname: homeManager:
    nixpkgs.lib.nixosSystem {
      modules =
        [
          {
            config = {
              networking.hostName = hostname;
            };
          }
          ./${hostname}
          ../modules/system
          inputs.sops-nix.nixosModules.sops
        ]
        ++ (
          if homeManager
          then [
            home-manager.nixosModules.home-manager
          ]
          else []
        );
      specialArgs = {inherit inputs;};
    };
in {
  nixosSystems = {
    tower = mkNixosSystem "tower" true;
    xi = mkNixosSystem "xi" true;
    shelf = mkNixosSystem "shelf" true;
    slab = mkNixosSystem "slab" true;
  };

  darwinSystems = {
    "M65L7Q9X32" = nix-darwin.lib.darwinSystem {
      modules = [
        ./portal/default.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.extraSpecialArgs = {inherit inputs;};
        }
      ];
      specialArgs = {inherit inputs home-manager;};
    };
  };
}
