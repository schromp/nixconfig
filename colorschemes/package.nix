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

    # Write the colorscheme data to a JSON file at build time
    cp ${pkgs.writeText "cs-data.json" (builtins.toJSON (lib.mapAttrs (program: data: {
      baseDir = if data ? baseDir then data.baseDir else null;
      inherit (data) directory activationScript supportedMetaAttributes;
      out = data.out;
      colorschemes = lib.mapAttrs (scheme: schemeData: {
        files = schemeData.files;
      }) data.colorschemes;
    }) colorschemeData))} $out/share/colorschemes/cs/lib/cs_data.json
    chmod +x $out/share/colorschemes/cs/cs.nu
  '';

  # Program activation scripts (static scripts, no quoting issues)
  neovimActivate = pkgs.writeScriptBin "neovim-activate" ''
    #!/usr/bin/env bash
    scheme="$1"
    for server in $(nvim --serverlist 2>/dev/null); do
        nvim --server "$server" --remote-expr 0 "colorscheme $scheme" 2>/dev/null
    done
  '';

  # CLI wrapper - pass paths via env
  cli = pkgs.writeScriptBin "cs" ''
    #!/usr/bin/env bash
    export COLORSCHEMES_OUT="${toString linkFarm}"
    export COLORSCHEMES_DATA_FILE="${cliFiles}/share/colorschemes/cs/lib/cs_data.json"
    export COLORSCHEMES_BIN="${neovimActivate}/bin"
    cd ${cliFiles}/share/colorschemes/cs
    exec ${pkgs.nushell}/bin/nu -I .:. ./cs.nu "$@"
  '';

in
pkgs.symlinkJoin {
  name = "colorschemes";
  paths = [
    linkFarm
    cli
    cliFiles
    neovimActivate
  ];
  passthru = {
    inherit colorschemeData;
  };
}