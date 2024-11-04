{lib, ...}: let
  getModules = import ../getModules.nix;
in {
  imports = getModules {
    inherit lib;
    type = "home";
  };
  # imports = [
  #   ./rio/rio.nix
  #   ./anyrun/anyrun.nix
  #   ./options.nix
  # ];
}
