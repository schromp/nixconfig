{ pkgs, lib, config, ... }: with lib; let
  opts = config.modules.user;
  username = config.modules.user.username;
in {
  config = mkIf (opts.homeManager.enabled && opts.appRunner == "tofi") {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        tofi
      ];
    };
  };
}
