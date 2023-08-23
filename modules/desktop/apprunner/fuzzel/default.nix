{
  lib,
  config,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.user.appRunner;
in {

  # TODO: split the fuzzel config into different option
  config = mkIf (cfg == "fuzzel") {
    home-manager.users.${username} = {
      programs.fuzzel = {
        enable = true;
        settings = {
          main.width = 60;

          colors = {
            background = "1F1F2800";
            text = "DCD7BAFF";
            match = "957FB8FF";
            selection = "223249aa";
            selection-match = "957FB8FF";
          };
        };
      };
    };
  };
}
