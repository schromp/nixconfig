{
  description = "inspired nixos system config";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://cosmic.cachix.org/"
      "https://hyprland.cachix.org"
      "https://vicinae.cachix.org"
      "https://cache.numtide.com"
      "https://veshell.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "veshell.cachix.org-1:C8J71PCJ1Fx4+4shICPNsSOnGgijVEHZCTrWhbYyjOI="
    ];
  };

  inputs = {
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

    # no nixpkgs follows: it pins nixpkgs to match the cached Flutter engine
    veshell.url = "github:free-explorers/veshell";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox.url = "github:nix-community/flake-firefox-nightly";
    firefox.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    # no nixpkgs follows, so the numtide binary cache actually hits
    llm-agents.url = "github:numtide/llm-agents.nix";

    tg = {
      url = "github:alyraffauf/tg";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    obsidian-skills = {
      url = "github:kepano/obsidian-skills";
      flake = false;
    };
    clickhouse-skills = {
      url = "github:ClickHouse/agent-skills";
      flake = false;
    };
    grafana-skills = {
      url = "github:grafana/skills";
      flake = false;
    };
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
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
      colorschemes-pkg = import ./colorschemes/package.nix {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
      };
    in
    {
      nixosConfigurations = hosts.nixosSystems;

      homeConfigurations = hosts.hmSystems;

      packages = import ./packages { inherit nixpkgs; };

      colorschemes = colorschemes-pkg;

      darwinConfigurations = hosts.darwinSystems;
    };
}
