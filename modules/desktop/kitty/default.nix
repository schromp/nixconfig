{
  lib,
  config,
  ...
}:
with lib; let
  username = import ../../../username.nix;
  cfg = config.modules.desktop.kitty;
in {
  options.modules.desktop.kitty = {
    enable = mkEnableOption "Enable Kitty";
    # TODO: add theming option
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.kitty = {
        enable = true;
        theme = "One Dark";
        extraConfig = builtins.readFile ./kitty.conf;
      };
    };
  };
}
