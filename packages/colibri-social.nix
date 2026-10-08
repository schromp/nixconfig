{appimageTools, fetchurl, lib, stdenv, ...}: let
  version = "0.6.0-spaces.2";
  appimage =
    if stdenv.hostPlatform.isAarch64 then {
      arch = "aarch64";
      hash = "sha256-R1AVZjcsITU8fKyAospLExufAaEZ0ytukYygyHuyPyE=";
    }
    else if stdenv.hostPlatform.isx86_64 then {
      arch = "amd64";
      hash = "sha256-qckqXleU9Ng6B2GUii+vdYP8CEnn9s9KvcNQlTbTm1k=";
    }
    else throw "colibri-social is only available on x86_64-linux and aarch64-linux";

  src = fetchurl {
    url = "https://github.com/colibri-social/colibri.social/releases/download/v${version}/Colibri.Social_${version}_${appimage.arch}.AppImage";
    inherit (appimage) hash;
  };
in
  appimageTools.wrapType2 (finalAttrs: {
    pname = "colibri-social";
    inherit version src;

    extraInstallCommands = ''
      install -Dm644 "${finalAttrs.contents}/usr/share/applications/Colibri Social.desktop" "$out/share/applications/colibri-social.desktop"
      install -Dm644 "${finalAttrs.contents}/Colibri Social.png" "$out/share/icons/hicolor/256x256/apps/colibri-social.png"
    '';

    meta = with lib; {
      description = "Colibri Social desktop client (preview release; data may reset between previews)";
      homepage = "https://colibri.social/";
      downloadPage = "https://github.com/colibri-social/colibri.social/releases/tag/v${version}";
      license = licenses.mit;
      mainProgram = "colibri-social";
      platforms = ["x86_64-linux" "aarch64-linux"];
    };
  })
