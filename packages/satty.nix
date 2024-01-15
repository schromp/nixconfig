{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkgs,
}: let
  version = "0.8.3";
in
  rustPlatform.buildRustPackage {
    pname = "Satty";
    inherit version;

    src = fetchFromGitHub {
      owner = "gabm";
      repo = "Satty";
      rev = "v${version}";
      hash = "sha256-KCHKR6DP8scd9xdWi0bLw3wObrEi0tOsflXHa9f4Z5k=";
    };

    cargoSha256 = "sha256-5ue1SUeFBXJcLBJbS3L52UHdft2BHEp9GD5Rm5FJCiY=";

    propagatedBuildInputs = with pkgs; [hicolor-icon-theme];
    nativeBuildInputs = with pkgs; [pkg-config];

    buildInputs = with pkgs; [cargo pango cairo libadwaita gtk4 gdk-pixbuf glib gnome.adwaita-icon-theme];

    meta = with lib; {
      description = "Satty: Modern Screenshot Annotation";
      homepage = "https://github.com/gabm/Satty";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  }
