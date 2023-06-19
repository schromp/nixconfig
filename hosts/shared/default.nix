{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      overlays = with inputs; [
        prismlauncher.overlay # TODO: move away
      ];
    };
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';

    settings = {
      auto-optimise-store = true;

      trusted-users = ["root" "@wheel"];

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  environment.systemPackages = with pkgs; [git curl coreutils vim htop ranger ];

  services = {
    dbus = {
      enable = true;
      packages = with pkgs; [dconf gcr udisks2];
    };
  };
}
