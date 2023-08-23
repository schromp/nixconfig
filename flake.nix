{
  description = "inspired nixos system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland"; 
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpaper.url = "github:hyprwm/hyprpaper"; 
    #xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    eww.url = "github:elkowar/eww";
    prismlauncher.url = "github:PrismLauncher/PrismLauncher";
    webcord.url = "github:fufexan/webcord-flake";

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
