{
  config,
  lib,
  ...
}: let
  cfg = config.modules.system.general.keymap;
in {
  config = lib.mkIf (cfg == "us-umlaute") {
    services.xserver.xkb = {
      layout = "us-german-umlaut";
      extraLayouts.us-greek = {
        description = "US layout with alt-gr german";
        languages = ["eng"];
        symbolsFile = ./us-german-umlaut;
      };
    };
  };
}
