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

  # applications
  spotify-player
  obsidian
  element-desktop
  signal-desktop
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
  (vesktop.override { withSystemVencord = false; })

  (pkgs.callPackage "${inputs.deadlock-mod-manager-nixpkgs}/pkgs/by-name/de/deadlock-modmanager/package.nix" { })
]
