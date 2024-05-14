{
  lib,
  ...
}: let
  modules = builtins.readDir ./.;
  # modules = {test = "";};

  importModule = name: let
    mod = import ./${name}/${name}.nix {inherit lib;};
  in
    mod.home;
in {
  imports = lib.mapAttrsToList (name: _: importModule name) modules;
}
