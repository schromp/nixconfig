{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  gtk3,
  pkgs,
}:
stdenvNoCC.mkDerivation {
  pname = "kanagawa-icon-theme";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Kanagawa-GKT-Theme";
    rev = "35936a1";
    hash = "sha256-BZRmjVas8q6zsYbXFk4bCk5Ec/3liy9PQ8fqFGHAXe0=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = with pkgs; [
    hicolor-icon-theme
  ];

  # avoid the makefile which is only for the theme maintainers
  dontBuild = true;
  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv icons/Kanagawa $out/share/icons/Kanagawa

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Kanagawa Icon theme";
    homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
