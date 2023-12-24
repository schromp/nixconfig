{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk-engine-murrine,
}: let
  version = "1.0";
in
  stdenvNoCC.mkDerivation {
    pname = "kanagawa-gtk-theme";
    inherit version;

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Kanagawa-GKT-Theme";
      rev = "35936a1";
      hash = "sha256-BZRmjVas8q6zsYbXFk4bCk5Ec/3liy9PQ8fqFGHAXe0=";
    };

    propagatedUserEnvPkgs = [
      gtk-engine-murrine
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes/Kanagawa
      cp -a themes/Kanagawa-B/* $out/share/themes/Kanagawa

      ls $out/share/themes

      runHook postInstall
    '';

    meta = with lib; {
      description = "Kanagawa GTK theme";
      homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  }
