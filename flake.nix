{
  description = "inspired nixos system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland"; 
    #nixos-hardware.url = "github:nixos/nixos-hardware";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpaper.url = "github:hyprwm/hyprpaper"; 
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    eww.url = "github:elkowar/eww";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs: let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = import ./hosts inputs;
  };
}
