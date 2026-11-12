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
  (callPackage ../../../packages/clickhousectl.nix { }) # for the ClickHouse infra-* agent skills
  # opencode

  # applications
  spotify
  # electron 43.8.7 breaks the renderer (webFrame defineProperty TypeError); drop once nixpkgs electron is fixed
  (obsidian.override { electron = electron_44; })
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
