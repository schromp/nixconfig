{ pkgs ? import <nixpkgs> { } }:

let
  lib = pkgs.lib;
  programs = lib.filterAttrs (
    n: type: type == "directory" && n != "lib"
  ) (builtins.readDir ./.);
  
  # Build colorscheme data for each program
  colorschemeData = lib.mapAttrs (program: _: 
    let
      meta = import ./${program};
      colorschemeFiles = lib.filterAttrs (
        n: type: type == "regular" && lib.hasSuffix ".nix" n && n != "default.nix"
      ) (builtins.readDir ./${program});
      colorschemes = lib.mapAttrs' (name: _: {
        name = lib.removeSuffix ".nix" name;
        value = import ./${program}/${name};
      }) colorschemeFiles;
      
      allFiles = lib.foldlAttrs (
        acc: schemeName: schemeData:
        acc // (lib.mapAttrs' (fileName: content: {
          name = "${schemeName}/${fileName}";
          value = content;
        }) schemeData.files)
      ) { } colorschemes;
      
      drv = pkgs.linkFarm "${program}-colorschemes" (
        lib.mapAttrsToList (path: content: {
          name = path;
          path = pkgs.writeText (lib.baseNameOf path) content;
        }) allFiles
      );
    in
    meta // {
      inherit colorschemes;
      out = drv;
    }
  ) programs;

  # The linkFarm containing all programs and their colorschemes
  linkFarm = pkgs.linkFarm "colorschemes" (
    lib.mapAttrsToList (program: data: {
      name = program;
      path = data.out;
    }) colorschemeData
  );

  # CLI scripts bundled as separate files
  cliFiles = pkgs.runCommand "cs-scripts" { } ''
    mkdir -p $out/share/colorschemes/cs/lib
    cp ${./cs.nu} $out/share/colorschemes/cs/cs.nu
    cp ${./lib/data.nu} $out/share/colorschemes/cs/lib/data.nu
    cp ${./lib/install.nu} $out/share/colorschemes/cs/lib/install.nu
    chmod +x $out/share/colorschemes/cs/cs.nu
  '';

  # CLI wrapper - pass all data via env
  cli = pkgs.writeScriptBin "cs" ''
    #!/usr/bin/env bash
    export COLORSCHEMES_OUT="${linkFarm}"
    export COLORSCHEMES_DATA='${builtins.toJSON (lib.mapAttrs (program: data: {
      baseDir = if data ? baseDir then data.baseDir else null;
      inherit (data) directory activationScript supportedMetaAttributes;
      out = data.out;
      colorschemes = lib.mapAttrs (scheme: schemeData: {
        files = schemeData.files;
      }) data.colorschemes;
    }) colorschemeData)}'
    cd ${cliFiles}/share/colorschemes/cs
    exec ${pkgs.nushell}/bin/nu cs.nu "$@"
  '';

in
pkgs.symlinkJoin {
  name = "colorschemes";
  paths = [
    linkFarm
    cli
    cliFiles
  ];
  passthru = {
    inherit colorschemeData;
  };
}