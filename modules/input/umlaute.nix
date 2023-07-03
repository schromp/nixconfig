{
  config,
  lib,
  ...
}:
with lib; let
  username = import ../../username.nix;
  cfg = config.modules.input.umlaute;
in {
  options.modules.input.umlaute.enable = mkEnableOption "Create Umlaute xkb layout";

  config = mkIf cfg.enable {
    services.xserver.layout = "us(altgr-intl)";
    home-manager.users.${username} = {
      xdg.configFile."xkb/symbols/us-german-umlaut".text = ''
        default partial alphanumeric_keys
        xkb_symbols "basic" {
          include "us(altgr-intl)"
          include "level3(caps_switch)"
          name[Group1] = "English (US, international with German umlaut)";
          key <AD03> { [ e, E, EuroSign, cent ] };
          key <AD07> { [ u, U, udiaeresis, Udiaeresis ] };
          key <AD09> { [ o, O, odiaeresis, Odiaeresis ] };
          key <AC01> { [ a, A, adiaeresis, Adiaeresis ] };
          key <AC02> { [ s, S, ssharp ] };
        };
      '';
    };
  };
}