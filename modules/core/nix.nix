{ config, pkgs, lib, inputs, ... }:
{
  environment = {
    # Something about backwards compability. Im not sure how or what exactly TODO
    etc = {
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
      "nix/flake-channels/home-manager".source = inputs.home-manager;
    };

    systemPackages = [ pkgs.git ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false; # TODO eval if this could be useful
    };

    # in here for me as an example
    overlays = with inputs; [];
  };

  nix = {
    # yes we do garbage collect now FANCY
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 4d";
    };
   
    # we are using unstable packages. ON THE EDGE!
    package = pkgs.nixUnstable;

    # something with backwards compa like above again
    nixPath = [
      "nixpkgs=/etc/nix/flake-channels/nixpkgs"
      "home-manager=/etc/nix/flake-channels/home-manager"
    ];

    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';

    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];

      substituters = [
        "https://cache.nixos.org"
	"https://nixpkgs-wayland.cachix.org"
	"https://nix-community.cachix.org"
	"https://hyprland.cachix.org"
      ];

      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ]; 
    };
  };

  system.autoUpgrade.enable = false; # no me do manually
  system.stateVersion = "22.11";
}
