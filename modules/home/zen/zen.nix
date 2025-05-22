{
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.programs.zen;
in {
  imports = [
    inputs.zen-browser.homeModules.beta
    # or inputs.zen-browser.homeModules.twilight
    # or inputs.zen-browser.homeModules.twilight-official
  ];

  options.modules.home.programs.zen = {
    enable = lib.mkEnableOption "Enable zen browser";
  };

  config = lib.mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      policies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
        # find more options here: https://mozilla.github.io/policy-templates/
      };
    };
  };
}
