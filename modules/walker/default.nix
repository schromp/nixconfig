{ inputs, config, lib, pkgs, ...}: with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.walker;
in {
  options.modules.programs.walker = {
    enable = mkEnableOption "Enable walker app runner";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = [ inputs.walker.packages.${pkgs.system}.default ];
    };

    # xdg.configFile 
  };
}
