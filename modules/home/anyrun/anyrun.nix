{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.home.programs.anyrun;
in {
  options.modules.home.programs.anyrun = {
    enable = lib.mkEnableOption "Enable Anyrun";
  };

  config = lib.mkIf cfg.enable {
    imports = [inputs.anyrun.homeManagerModules.default];

    programs.anyrun = {
      enable = true;
      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          # randr
          rink
          shell
          symbols
          translate
          stdin
        ];
        x = {fraction = 0.5;};
        y = {absolute = 15;};
        width = {fraction = 0.3;};
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = false;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = null;
      };

      extraCss = builtins.readFile ./style-dark.css;

      extraConfigFiles."symbols.ron".text = ''
        Config(
          prefix: "sym ",
          symbols: {
            "shrug": "¯\\_(ツ)_/¯",
            ""
          },
          max_entries: 3,
        )
      '';
    };
    # substituters to use
    # nix.settings = {
    #   substituters = [
    #     "https://anyrun.cachix.org"
    #   ];
    #
    #   trusted-public-keys = [
    #     "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    #   ];
    # };
  };
}
