{ pkgs, inputs, ... }:
with pkgs;
[

  # cli
  tldr
  unzip
  helix
  lazygit
  unrar
  kubectl
  kubernetes-helm
  helmfile
  bitwarden-cli
  jujutsu
  lazyjj
  lazysql
  gh
  gemini-cli
  opencode

  # applications
  spotify-player
  obsidian
  element-desktop
  # signal-desktop
  nomacs
  krita
  pureref
  inkscape
  loupe
  celluloid
  thunderbird
  localsend
  heroic
  libation
  calibre
  orca-slicer
  discord
  mission-center
  blockbench
  gnome-calendar
  geary
  owncloud-client
  # logseq
  # affine
  libreoffice

  # (vesktop.override { withSystemVencord = false; })

  ((pkgs.callPackage "${inputs.fluxer-bin}/pkgs/by-name/fl/fluxer-bin/package.nix" { }).overrideAttrs
    (oldAttrs: {
      src = pkgs.fetchurl {
        url = "https://api.canary.fluxer.app/dl/desktop/canary/linux/x64/v2026.602.31138/appimage";
        hash = "sha256-d4FAWwrWyoyp7lo8X+nIe+Dd6Z8rDThyK1wU00f7rjY=";
      };
    })
  )
]
