{
  config,
  lib,
  kind,
  ...
}: let
  modules = builtins.readDir ./.;
  # modules = {test = "";};
  importModule = name: let
    mod = import ./${name}/${name}.nix {inherit config lib;};
  in
    if kind == "nixos"
    then mod.system
    else if kind == "homeManager"
    then mod.home
    else mod.system;
in {
  # TODO: create list not map/set
  imports = lib.mapAttrsToList (name: _: (importModule)) modules;

  # imports = [
  #   (importModule "test")
  # ];

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
