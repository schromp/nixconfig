{
  config,
  lib,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.gamescope;
in {
  options.modules.programs.gamescope.enable = mkEnableOption "Enable Gamescope";

  config = mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
    };

    home-manager.users.${username} = {
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
  };
}
