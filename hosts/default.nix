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
in {
  tower = mkNixosSystem "x86_64-linux" "tower";
}
