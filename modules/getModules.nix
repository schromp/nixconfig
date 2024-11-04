{
  lib,
  type,
  ...
}: let
  modules = lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./${type}/.);

  importModule = name: ./${type}/${name}/${name}.nix;
in
  lib.mapAttrsToList (name: _: importModule name) modules ++ [./${type}/options.nix]
