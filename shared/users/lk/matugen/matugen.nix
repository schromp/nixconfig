{ pkgs, config, lib, ... }:
let
  matugen-themes = pkgs.fetchFromGitHub {
    owner = "InioX";
    repo = "matugen-themes";
    rev = "main";
    sha256 = "sha256-XhQVvhwHAmnles30A9BINsNWq73rsy+/mulfpDOBTp0=";
  };

  vicinae-theme = pkgs.fetchFromGitHub {
    owner = "vicinaehq";
    repo = "vicinae";
    rev = "v0.16.2";
    sha256 = "sha256-CNL45FJG8JAtFFbc8V8Hhf+RwZuWXFwz/v5E1yAi1bQ=";
  };

  combined-templates = pkgs.stdenv.mkDerivation {
    name = "matugen-combined-templates";
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out
      cp -r ${matugen-themes}/templates/* $out/
      cp -r ${./templates}/* $out/
      cp ${vicinae-theme}/extra/matugen.toml $out/vicinae.toml
    '';
  };
in
{
  home.packages = [
    pkgs.matugen
    pkgs.pywalfox-native
  ];

  home.file.".config/matugen/templates".source = combined-templates;
  home.file.".config/matugen/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink /home/lk/repos/nixconfig/shared/users/lk/matugen/config.toml;

  home.file.".config/gtk-3.0/gtk.css".text = ''
    @import 'colors.css';
  '';
  home.file.".config/gtk-4.0/gtk.css".text = ''
    @import 'colors.css';
  '';
}
