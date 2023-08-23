{ config, lib, pkgs, ... }: with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.zellij;
in {

  options.modules.programs.zellij = {
    enable = mkEnableOption "Enable zellij";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ zellij ];

    home-manager.users.${username} = {
      xdg.configFile."zellij/config.kdl".text = builtins.readFile ./config.kdl;
      xdg.configFile."zellij/layouts/default.kdl".text = builtins.readFile ./layouts/default.kdl;
    };

  };

}
