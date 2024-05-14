{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  # modules = lib.filterAttrs (n: v: v == "directory") (builtins.readDir ../modules);
  modules = {
    themes = "";
  };

  importOptions = name: let
    mod = import ./${name}/${name}.nix {inherit lib config inputs pkgs;};
  in
    if builtins.hasAttr "options" mod
    then mod.options
    else {};
in {
  imports =
    [
      ./system.nix
      ./user.nix
    ]
    ++ lib.mapAttrsToList (name: _: importOptions) modules;
}
