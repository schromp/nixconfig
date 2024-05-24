{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = config.modules.user.username;
  cfg = config.modules.programs.zellij;
in {
  options.modules.programs.zellij = {
    enable = lib.mkEnableOption "Enable zellij";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [zellij];

    home-manager.users.${username} = {
      xdg.configFile."zellij/config.kdl".text = builtins.readFile ./config.kdl;
      xdg.configFile."zellij/layouts/default.kdl".text = builtins.readFile ./layouts/default.kdl;
    };
  };
}
