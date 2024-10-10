{lib, ...}: let
  getModules = import ../getModules.nix;
in {
  imports = getModules {
    inherit lib;
    type = "home";
  };
}
