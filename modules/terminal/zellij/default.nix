{ config, lib, pkgs, ... }: with lib; let
  username = import ../../../username.nix;
  cfg = config.modules.programs.zellij;
in {

  options.modules.programs.zellij = {
    enable = mkEnableOption "Enable zellij";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ zellij ];

    home-manager.users.${username} = {
      xdg.configFile."zellij/config.kdl".text = builtins.readFile ./config.kdl;
    };

  };

}
