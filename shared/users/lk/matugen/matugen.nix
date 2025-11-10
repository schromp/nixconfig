{ pkgs, config, ... }:
let
  matugen-themes = pkgs.fetchFromGitHub {
    owner = "InioX";
    repo = "matugen-themes";
    rev = "main";
    sha256 = "sha256-loFuvBqNT1As9I2gSZ2FxaqaDYbMh9xPVUsKBPlxI7M=";
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
  ];

  home.file.".config/matugen/templates".source = combined-templates;
  home.file.".config/matugen/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink /home/lk/repos/nixconfig/shared/users/lk/matugen/config.toml;
}
