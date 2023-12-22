{
  nixpkgs,
  inputs,
  home-manager,
  nix-darwin,
  ...
}: let
  mkNixosSystem = system: hostname:
    nixpkgs.lib.nixosSystem {
      system = "${system}";
      modules = [
        {
          config.modules.system = {
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
