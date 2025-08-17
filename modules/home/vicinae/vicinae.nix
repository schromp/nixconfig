{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.vicinae;
  vicVersion = "0.2.1";

  vicinaeExtraThemes = pkgs.stdenv.mkDerivation rec {
    pname = "vicinae-extra-themes";
    version = vicVersion;

    src = pkgs.fetchFromGitHub {
      owner = "vicinaehq";
      repo = "vicinae";
      rev = "v${vicVersion}";
      sha256 = "sha256-gcMxha7BwgVH7Lw/024J01ICbvmLCEyK/stkrZni7UA=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/vicinae
      cp -r extra/themes $out/share/vicinae/
    '';
  };

  vicinae = pkgs.stdenv.mkDerivation rec {
    pname = "vicinae";
    version = vicVersion;

    src = pkgs.fetchurl {
      url = "https://github.com/vicinaehq/vicinae/releases/download/v${vicVersion}/vicinae-linux-x86_64-v${version}.tar.gz";
      sha256 = "sha256-c2YC/i2yul3IKasUexKrW0o87HE8X60aBzkS+I7nnQI=";
    };

    nativeBuildInputs = with pkgs; [autoPatchelfHook qt6.wrapQtAppsHook];
    buildInputs = with pkgs; [
      qt6.qtbase
      qt6.qtsvg
      qt6.qttools
      qt6.qtwayland
      qt6.qtdeclarative
      qt6.qt5compat
      kdePackages.qtkeychain
      kdePackages.layer-shell-qt
      openssl
      cmark-gfm
      libqalculate
      minizip
      stdenv.cc.cc.lib
      abseil-cpp
      protobuf
      nodejs
      wayland
      wayland-utils
      wl-clipboard
    ];

    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share/applications
      cp bin/vicinae $out/bin/
      cp share/applications/vicinae.desktop $out/share/applications/
      chmod +x $out/bin/vicinae
    '';

    dontWrapQtApps = true;

    preFixup = ''
      wrapQtApp "$out/bin/vicinae" --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
    '';

    meta = {
      description = "A focused launcher for your desktop — native, fast, extensible";
      homepage = "https://github.com/vicinaehq/vicinae";
      license = pkgs.lib.licenses.gpl3;
      maintainers = [];
      platforms = pkgs.lib.platforms.linux;
    };
  };
in {
  options.services.vicinae = {
    enable = mkEnableOption "vicinae launcher daemon" // {default = true;};

    package = mkOption {
      type = types.package;
      default = vicinae;
      defaultText = literalExpression "vicinae";
      description = "The vicinae package to use.";
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start the vicinae daemon automatically on login.";
    };

    linkExtraThemes = mkOption {
      type = types.bool;
      default = false;
      description = "Symlink vicinae extra themes into the config directory.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    home.file."${config.xdg.configHome}/vicinae/themes" = mkIf cfg.linkExtraThemes {
      source = "${vicinaeExtraThemes}/share/vicinae/themes";
      recursive = true;
    };

    systemd.user.services.vicinae = {
      Unit = {
        Description = "Vicinae launcher daemon";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/vicinae server";
        Restart = "on-failure";
        RestartSec = 3;
        Environment = [
          "PATH=${config.home.profileDirectory}/bin"
        ];
      };

      Install = mkIf cfg.autoStart {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
