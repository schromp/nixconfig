{
  lib,
  config,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.kitty;
in {
  options.modules.programs.kitty = {
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
