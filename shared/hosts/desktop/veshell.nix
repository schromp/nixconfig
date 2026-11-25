{ inputs, pkgs, ... }:
let
  # Upstream builds everything against its own pinned nixpkgs. That binary then
  # can't load our system Mesa (/run/opengl-driver needs a newer glibc), so it
  # dies at "Failed to initialize gbm device". Rebuild only the Rust binary
  # against our nixpkgs and reuse upstream's Flutter engine + shell bundle,
  # which stay cached (they only need libc/libm/libgcc/fontconfig).
  upstream = inputs.veshell.packages.${pkgs.stdenv.hostPlatform.system}.veshell;
  dependencies = pkgs.callPackage "${inputs.veshell}/nix/dependencies.nix" { };
  veshell = pkgs.callPackage "${inputs.veshell}/nix/package.nix" {
    inherit (upstream.passthru) flutterSdk shellBundle flutterEngine;
    inherit (dependencies) cargoHash;
    buildCommit = inputs.veshell.rev;
  };
in
{
  # Veshell: Flutter/Rust Wayland session (https://github.com/free-explorers/veshell)
  # Shows up as a session in cosmic-greeter.
  imports = [ inputs.veshell.nixosModules.default ];

  programs.veshell = {
    enable = true;
    package = veshell;
  };

  # Without this cache the Flutter engine compiles from source (and currently fails).
  nix.settings = {
    extra-substituters = [ "https://veshell.cachix.org" ];
    extra-trusted-public-keys = [
      "veshell.cachix.org-1:C8J71PCJ1Fx4+4shICPNsSOnGgijVEHZCTrWhbYyjOI="
    ];
  };
}
