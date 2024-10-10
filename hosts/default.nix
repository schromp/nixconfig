{
  nixpkgs,
  inputs,
  home-manager,
  home-manager-darwin,
  nix-darwin,
  ...
}: let
  mkNixosSystem = system: hostname: homeManager:
    nixpkgs.lib.nixosSystem {
      system = "${system}";
      modules =
        [
          {
            config = {
              modules.system.general = {
                hostname = hostname;
                architecture = system;
              };
              networking.hostName = hostname;
            };
          }
          ./${hostname}
          ../modules/system
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

  mkHmSystem = system: hostname:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        ./${hostname}
      ];
    };
in {
  nixosSystems = {
    tower = mkNixosSystem "x86_64-linux" "tower" true;
    xi = mkNixosSystem "x86_64-linux" "xi" true;
    shelf = mkNixosSystem "x86_64-linux" "shelf" true;
    # cake = mkNixosSystem "aarch64" "cake";
  };

  hmSystems = {
    submarine = mkHmSystem "x86_64-linux" "submarine";
    work = mkHmSystem "x86_64-linux" "work";
  };

  darwinSystems = {
    "M65L7Q9X32" = nix-darwin.lib.darwinSystem {
      modules = let
        home-manager = home-manager-darwin;
      in [
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
