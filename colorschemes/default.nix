let
  lib = import <nixpkgs/lib>;
  pkgs = import <nixpkgs> {};
  entries = builtins.readDir ./.;
  programs = lib.filterAttrs (n: type: type == "directory") entries;
  programsAndThemes = lib.mapAttrs (
    program: _:
    let
      # Base values of the program (default.nix)
      meta = import ./${program};
      # Colorscheme file values (e.g. catppuccin.nix)
      colorschemeFiles = lib.filterAttrs (
        n: type: type == "regular" && lib.hasSuffix ".nix" n && n != "default.nix"
      ) (builtins.readDir ./${program});
      # Colorschemes in a set with correct names
      colorschemes = lib.mapAttrs' (name: _: {
        name = lib.removeSuffix ".nix" name;
        value = import ./${program}/${name};
      }) colorschemeFiles;
      # Build derivations for the colorschemes
      colorschemesWithDerivations = lib.mapAttrs (
        schemeName: schemeData:
        let
          drv = pkgs.linkFarm "${program}-${schemeName}" (
            lib.mapAttrsToList (path: content: {
              name = path;
              path = pkgs.writeText (baseNameOf path) content;
            }) schemeData.files
          );
        in
        schemeData // { out = drv; }
      ) colorschemes;
    in
    meta // { colorschemes = colorschemesWithDerivations; }
  ) programs;

  # Activation Script
in
programsAndThemes
