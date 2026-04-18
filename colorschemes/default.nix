let
  lib = import <nixpkgs/lib>;
  pkgs = import <nixpkgs> { };
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
      allFiles = lib.foldlAttrs (
        acc: schemeName: schemeData:
        acc
        // (lib.mapAttrs' (fileName: content: {
          name = "${schemeName}/${fileName}";
          value = content;
        }) schemeData.files)
      ) { } colorschemes;

      # Single derivation per program
      drv = pkgs.linkFarm "${program}-colorschemes" (
        lib.mapAttrsToList (path: content: {
          name = path;
          path = pkgs.writeText (baseNameOf path) content;
        }) allFiles
      );
    in
    meta
    // {
      colorschemes = colorschemes;
      out = drv;
    }
  ) programs;

  # Activation Script
in
programsAndThemes
