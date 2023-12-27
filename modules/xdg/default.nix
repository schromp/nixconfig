{
  config,
  pkgs,
  lib,
  ...
}: with lib; let
  username = config.modules.user.username;
  cfg = config.modules.user.createXDGDirectories;
in {
  options.modules.user.createXDGDirectories = mkEnableOption "Create preset home directories";

  config = mkIf cfg {
    home-manager.users.${username} = {
      xdg = {
        userDirs = {
          enable = true;
          createDirectories = true;
          extraConfig = {
            Wallpapers = "/home/${username}/Documents/Wallpapers";
          };
        };
      };
    };
  };
}
