{
  lib,
  ...
}:
with lib; let
  cfg = options.modules.desktop.kitty;
in {
  cfg = {
    enable = mkEnableOption "Enable Kitty";
    # TODO: add theming option
  };

  config = {
    kitty = mkIf cfg.enable {
      programs.kitty = {
        enable = true;
        theme = "One Dark";
        extraConfig = builtins.readFile ./kitty.conf;
      };
    };
  };
}
