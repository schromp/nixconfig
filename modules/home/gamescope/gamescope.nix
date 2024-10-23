{
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.gamescope;
in {
  options.modules.home.programs.gamescope.enable = lib.mkEnableOption "Enable Gamescope";

  config = lib.mkIf cfg.enable {
    home.file.overwatch = {
      text = ''
        gamescope -W 3440 -H 1440 -f -- steam steam://rungameid/2357570
      '';
      target = "scripts/games/overwatch.sh";
      executable = true;
    };
    home.file.deepRockGalactic = {
      text = ''gamescope -W 3440 -H 1440 -f -- steam steam://rungameid/548430 '';
      target = "scripts/games/deepRockGalactic.sh";
      executable = true;
    };
  };
}
