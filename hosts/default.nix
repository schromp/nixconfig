{
  nixpkgs,
  inputs,
  home-manager,
  home-manager-darwin,
  nix-darwin,
  ...
}: let
  mkNixosSystem = system: hostname:
    nixpkgs.lib.nixosSystem {
      system = "${system}";
      modules = [
        {
          config.modules.system.general = {
            hostname = hostname;
            architecture = system;
          };
        }
        home-manager.nixosModules.home-manager
        ./${hostname}
        {networking.hostName = hostname;}
      ];
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
    tower = mkNixosSystem "x86_64-linux" "tower";
    xi = mkNixosSystem "x86_64-linux" "xi";
    shelf = mkNixosSystem "x86_64-linux" "shelf";
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
          home-manager.extraSpecialArgs = {inherit inputs; };
        }
      ];
      specialArgs = { inherit inputs home-manager; };
    };
  };
}
