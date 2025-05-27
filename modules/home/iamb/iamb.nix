{
  config,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.iamb;
in {
  options.modules.home.programs.iamb = {
    enable = lib.mkEnableOption "Enable IAMB";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."iamb/config.toml".text = ''
      default_profile = "schromp"

      [profiles.schromp]
      user_id = "@schromp:echsen.club"

      [settings.image_preview]
      protocol.type = "sixel"
    '';
  };
}
