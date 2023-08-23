{
  lib,
  ...
}:
with lib; let
  cfg = options.modules.desktop.fuzzel;
in {
  options.modules.desktop.fuzzel.enable = mkEnableOption "Enable fuzzel";

  # TODO: split the fuzzel config into different option
  config = mkIf cfg.enable {
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
}
