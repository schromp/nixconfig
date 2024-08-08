{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
    };
  };

  nix = {
    package = pkgs.nixVersions.git;
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    settings = {
      auto-optimise-store = true;

      trusted-users = ["root" "@wheel"];
      builders-use-substitutes = false;

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cosmic.cachix.org/"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      ];
    };
  };

  environment.systemPackages = with pkgs; [git curl coreutils vim ranger];

  services = {
    dbus = {
      enable = true;
      packages = with pkgs; [dconf gcr udisks2];
    };
  };
}
