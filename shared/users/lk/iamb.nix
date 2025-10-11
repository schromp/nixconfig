{ ... }:
{
  xdg.configFile."iamb/config.toml".text = ''
    default_profile = "schromp"

    [profiles.schromp]
    user_id = "@schromp:echsen.club"

    [settings.image_preview]
    protocol.type = "sixel"
  '';
}
