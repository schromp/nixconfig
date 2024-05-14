{
  nixpkgs,
  inputs,
  home-manager,
  ...
}: let
  mkNixosSystem = system: hostname:
    nixpkgs.lib.nixosSystem {
      system = "${system}";
      modules = [
        ./${hostname}
        ../options
        ../modules/system.nix
        {
          config.modules.system = {
            hostname = hostname;
            architecture = system;
          };
        }
        {
          networking.hostName = hostname;
        }
        home-manager.nixosModules.home-manager
      ];
      specialArgs = {inherit inputs;};
    };

  mkHmSystem = system: hostname:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};

      modules = [
        ./${hostname}
        ../options
        ../modules/home.nix
      ];
    };
in {
  nixosSystems = {
    tower = mkNixosSystem "x86_64-linux" "tower";
    xi = mkNixosSystem "x86_64-linux" "xi";
    # cake = mkNixosSystem "aarch64" "cake";
  };

  hmSystems = {
    submarine = mkHmSystem "x86_64-linux" "submarine";
    work = mkHmSystem "x86_64-linux" "work";
  };

  # darwinSystems = {
  #   viajar = mkDarwinSystem "x86_64-darwin" "viajar";
  # };
}
