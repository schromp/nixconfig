{
  config,
  lib,
  ...
}: let
  test = import ./test/test.nix {inherit lib;};
  # modules = builtins.readDir ./.;
  modules = {test = "";};
  kind = config.modules.system.kind; # FIX: this leads to infinite recursion
  # kind = "nixos";
  importModule = name: let
    mod = import ./${name}/${name}.nix {inherit config lib;};
  in
    if config.modules.system.kind == "nixos"
    then mod.system
    else if kind == "homeManager"
    then mod.home
    else mod.system;
in {
  # TODO: create list not map/set
  # imports = lib.mapAttrsToList (name: _: (importModule)) modules;

  # options.modules.testing = lib.mkEnableOption "";

  imports = [
    # test.system
    (importModule "test")
  ];

  # imports = [
  #   ./options
  #   ./common
  #
  #   ./input
  #   ./system
  #
  #   # Gaming
  #   ./prismlauncher
  #   ./lutris
  #   ./bottles
  #   ./steam
  #   ./retroarch
  #   ./gamescope
  #   ./gamemode
  #
  #   # Desktop
  #   ./swww
  #   ./eww
  #   ./waybar
  #   ./kitty
  #   ./pipewire
  #   ./libreoffice
  #   ./discord
  #   ./ags
  #   ./anyrun
  #   ./tofi
  #   ./xdg
  #   ./qutebrowser
  #   ./obsidian
  #
  #   ./displaymanager
  #   ./windowmanager
  #   ./sway
  #   ./apprunner
  #   ./walker
  #   ./udiskie
  #
  #   # Terminal
  #   ./git
  #   ./zsh
  #   ./zoxide
  #   ./tmux
  #   ./direnv
  #   ./neovim
  #   ./zellij
  #   ./greetd
  #   ./ssh
  #   ./nh
  #
  #   ./themes
  # ];
}
