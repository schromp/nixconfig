{ lib
, writeText
, fetchurl
, stdenvNoCC
, copyDesktopItems
, makeDesktopItem
, unzip
, bash
, electron
, commandLineArgs ? ""
}:

stdenvNoCC.mkDerivation (finalAttrs: let
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/toeverything/AFFiNE/v${finalAttrs.version}/packages/frontend/core/public/favicon-192.png";
    hash = "sha256-smZ5W7fy3TK3bvjwV4i71j2lVmKSZcyhMhcWfPxNnN4=";
  };
  script = writeText "affine" ''
    #!${bash}/bin/bash
    set -e
    export ELECTRON_IS_DEV=0
    export ELECTRON_FORCE_IS_PACKAGED=true
    export NODE_ENV=production
    cd @out@
    if [[ $EUID -ne 0 ]] || [[ $ELECTRON_RUN_AS_NODE ]]; then
        exec ${electron}/bin/electron @out@/lib/app.asar ''${NIXOS_OZONE_WL:+''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}} ${commandLineArgs} "$@"
    else
        exec ${electron}/bin/electron @out@/lib/app.asar ''${NIXOS_OZONE_WL:+''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}} ${commandLineArgs} --no-sandbox "$@"
    fi
  '';
in {
  pname = "affine";
  version = "0.13.1";
  src = fetchurl {
    url = "https://github.com/toeverything/AFFiNE/releases/download/v${finalAttrs.version}/affine-${finalAttrs.version}-stable-linux-x64.zip";
    hash = "sha256-2Du5g/I82iTr8Bwb+qkLzyfbk1OrOlXqx6FHImVoAoE=";
  };
  nativeBuildInputs = [
    copyDesktopItems
  ];
  sourceRoot = ".";
  unpackPhase = ''
    mkdir $out
    ${unzip}/bin/unzip $src -d $out
  '';
  postInstall = ''
    mkdir -p $out/lib
    cp -r $out/AFFiNE-linux-x64/resources/* -t $out/lib/
    install -Dm644 ${icon} $out/share/pixmaps/affine.png
    install -Dm755 ${script} $out/bin/affine
    substituteInPlace $out/bin/affine --replace @out@ $out
    rm -rf $out/AFFiNE-linux-x64
  '';
  desktopItems = [
    (makeDesktopItem {
      name = "affine";
      desktopName = "AFFiNE";
      exec = "affine %U";
      terminal = false;
      icon = "affine";
      startupWMClass = "affine";
      categories = ["Utility"];
    })
  ];
  meta = with lib; {
    description = ''
      AFFiNE is an open-source, all-in-one workspace and an operating
      system for all the building blocks that assemble your knowledge
      base and much more -- wiki, knowledge management, presentation
      and digital assets
    '';
    homepage = "https://affine.pro/";
    downloadPage = "https://affine.pro/download";
    license = licenses.mit;
    maintainers = with maintainers; [richar];
    mainProgram = "affine";
    platforms = ["x86_64-linux"];
  };
})
