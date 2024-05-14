{
  nixpkgs,
  inputs,
  home-manager,
  nix-darwin,
  ...
}: let
  lib = nixpkgs.lib;
  config = nixpkgs.config;
  mkNixosSystem = system: hostname:
    nixpkgs.lib.nixosSystem {
      system = "${system}";
      modules = [
        ../options
        (import ../modules {inherit config lib inputs; kind = "nixos";})
        {
          config.modules.system = {
            hostname = hostname;
            architecture = system;
            kind = "nixos";
          };
        }
        {
          networking.hostName = hostname;
        }
        home-manager.nixosModules.home-manager
        ./${hostname}
      ];
      specialArgs = {inherit inputs;};
    };

  mkHmSystem = system: hostname:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};

      modules = [
        ../options
        (import ../modules {inherit config lib inputs; kind = "homeManager";})
        {
          config.modules.system = {
            kind = "nixos";
          };
        }
        ./${hostname}
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
