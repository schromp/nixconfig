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
  # mkDarwinSystem = system: hostname:
  #   nix-darwin.lib.darwinSystem {
  #     # nixpkgs.hostPlatform = "${system}";
  #     system = "${system}";
  #     modules = [
  #       {
  #         config.modules.system = {
  #           hostname = hostname;
  #           architecture = system;
  #         };
  #       }
  #       home-manager.darwinModules.home-manager
  #       ./${hostname}
  #     ];
  #     specialArgs = {inherit inputs;};
  #   };
in {
  nixosSystems = {
    tower = mkNixosSystem "x86_64-linux" "tower";
    cake = mkNixosSystem "aarch64" "cake";
  };

  # darwinSystems = {
  #   viajar = mkDarwinSystem "x86_64-darwin" "viajar";
  # };
}
