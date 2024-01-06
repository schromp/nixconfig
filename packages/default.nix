{nixpkgs, ...}: let
  forAllSystems = function:
    nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ] (system: function nixpkgs.legacyPackages.${system});
in
  forAllSystems (pkgs: {
    kanagawa-gtk-theme = pkgs.callPackage ./kanagawa-gtk-theme.nix {};
    kanagawa-icon-theme = pkgs.callPackage ./kanagawa-icon-theme.nix {};
    tmux-powerline = pkgs.callPackage ./tmux-powerline.nix {};
  })
