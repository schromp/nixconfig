{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.kitty;
in {
  options.modules.desktop.kitty = {
    enable = mkEnableOption "Enable Kitty";
    # TODO: add theming option
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      theme = "One Dark";
      extraConfig = builtins.readFile ./kitty.conf;
    };
  };
}
