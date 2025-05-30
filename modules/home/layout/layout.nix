{config, lib, ...}: let
  cfg = config.modules.home.general.keymap;
in {
  config = lib.mkIf (cfg == "us-umlaute") {
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
}
