{
  description = "inspired nixos system config";

  inputs = {
    nixpkgs-xwayland-satellite.url = "github:Nixos/nixpkgs/pull/466734/head";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-25-05.url = "github:NixOS/nixpkgs/nixos-25.05";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-avf.url = "github:nix-community/nixos-avf";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    non_public_files = {
      url = "path:/home/lk/repos/nixconfig_private";
      flake = false;
    };

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?rev=2566d818848b58b114071f199ffe944609376270&submodules=1";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    vicinae.url = "github:vicinaehq/vicinae";

    awww.url = "git+https://codeberg.org/LGFae/awww";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:niri-wm/niri/pull/3483/head";

    fluxer.url = "github:NixOS/nixpkgs/pull/497870/merge";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }@inputs:
    let
      hosts = import ./hosts {
        inherit
          inputs
          home-manager
          nixpkgs
          nix-darwin
          ;
      };
      # pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in
    {
      nixosConfigurations = hosts.nixosSystems;

      homeConfigurations = hosts.hmSystems;

      packages = import ./packages { inherit nixpkgs; };

      darwinConfigurations = hosts.darwinSystems;
    };
}
