{ nixpkgs, self, hyprland, ... }:
let
  inputs = self.inputs; # make flake inputs accessible
  bootloader = ../modules/core/bootloader.nix;
  core = ../modules/core;
  wayland = ../modules/wayland;
  hmModule = inputs.home-manager.nixosModules.home-manager;


  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs; # make flake inputs accessible to home manager
      inherit self;
    };
    users.lk = ../modules/home; # where the user config lifes
  };
in
{

  xi = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux"; # double defined this FIX
    modules = [
      {
        networking.hostName = "xi";
      }
      ./xi/hardware-configuration.nix
      bootloader
      core
      wayland
      hmModule
      { inherit home-manager; } # this pulls down the config we have defined in let
    ];
    specialArgs = { inherit inputs; };
  };

  # Can add more systems here later
tower = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux"; # double defined this FIX
  modules = [
    {
      networking.hostName = "tower";
    }
    ./tower/hardware-configuration.nix
    bootloader
    core
    wayland
    hmModule
    #nvidia
    #hyprlandModule
    hyprland.nixosModules.default
    { programs.hyprland = {
        enable = true;
        nvidiaPatches = true;
      };
    }
    { inherit home-manager; } # this pulls down the config we have defined in let
  ];
  specialArgs = { inherit inputs; };
};

}
