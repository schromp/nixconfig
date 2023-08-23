{
  nixpkgs,
  self,
  ...
}: let
  inputs = self.inputs; # make flake inputs accessible
  hmModule = inputs.home-manager.nixosModules.home-manager;

  mkNixosSystem = system: hostname: user: (
    nixpkgs.lib.nixosSystem {
      system = "${system}";
      modules = [
        ./${hostname}
        hmModule
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit inputs;
            };
            users.${user} = ./${hostname}/user.nix;
          };
        }
        {networking.hostName = hostname;}
      ];
      specialArgs = {inherit inputs;};
    }
  );
in {
  tower = mkNixosSystem "x86_64-linux" "tower" "lk";
}
