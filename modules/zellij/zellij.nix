{
  config,
  lib,
  pkgs,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.zellij;
in {
  options.modules.programs.zellij = {
    enable = lib.mkEnableOption "Enable zellij";
  };

  home = {
    config = lib.mkIf cfg.enable {
      home-manager.users.${username} = {
        programs.zellij.enable = true;
        xdg.configFile."zellij/config.kdl".text = builtins.readFile ./config.kdl;
        xdg.configFile."zellij/layouts/default.kdl".text = builtins.readFile ./layouts/default.kdl;
      };
    };
  };
}
