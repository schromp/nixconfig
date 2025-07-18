{
  description = "inspired nixos system config";

  inputs = {
    netbird-new-module.url = "github:NixOS/nixpkgs/pull/354032/head";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?rev=2566d818848b58b114071f199ffe944609376270&submodules=1";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

    # nixos-cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    eww.url = "github:elkowar/eww";

    prismlauncher.url = "github:PrismLauncher/PrismLauncher";
    nix-gaming.url = "github:fufexan/nix-gaming";

    webcord.url = "github:fufexan/webcord-flake";
    arrpc = {
      url = "github:notashelf/arrpc-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    ags.url = "github:Aylur/ags";

    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    tmux-sessionx = {
      url = "github:omerxx/tmux-sessionx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    themer = {
      url = "github:schromp/themer";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker = {
      url = "github:abenz1267/walker/v0.12.23";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    rustacean = {
      url = "github:mrcjkb/rustaceanvim";
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

    schildichat = {
      url = "github:SchildiChat/schildichat-desktop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
<<<<<<< HEAD
    mcphub-nvim.url = "github:ravitemer/mcphub.nvim";
=======

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
>>>>>>> quickshell-init
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    home-manager-darwin,
    nix-darwin,
    ...
  } @ inputs: let
    hosts = import ./hosts {inherit inputs home-manager home-manager-darwin nixpkgs nix-darwin;};
    # pkgs = nixpkgs.legacyPackages."x86_64-linux";
  in {
    nixosConfigurations = hosts.nixosSystems;

    homeConfigurations = hosts.hmSystems;

    packages = import ./packages {inherit nixpkgs;};

    darwinConfigurations = hosts.darwinSystems;
  };
}
