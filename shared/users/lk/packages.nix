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
  inputs.tg.packages.${pkgs.stdenv.hostPlatform.system}.tg # tangled cli
  # opencode

  # applications
  spotify
  obsidian
  signal-desktop
  nomacs
  krita
  pureref
  inkscape
  loupe # image viewer
  celluloid # video player
  evince # pdf
  vlc
  thunderbird
  heroic
  libation # audible stuff
  orca-slicer
  discord
  blockbench
  gnome-calendar
  libreoffice
  qpwgraph
  openlinkhub
  openrgb
  gimp
  nautilus
  chromium

  zed-editor
  claude-code
  claude-agent-acp

  # (vesktop.override { withSystemVencord = false; })
]
