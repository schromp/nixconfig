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
  mission-center
  blockbench
  # (vesktop.override { withSystemVencord = false; })
]
