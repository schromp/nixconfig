{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.eww;
  pkg =
    if config.modules.user.displayServerProtocol == "wayland"
    then pkgs.eww-wayland
    else pkgs.eww;
in {
  options.modules.home.programs.eww = {
    enable = lib.mkEnableOption "Enable Eww";
  };

  config = lib.mkIf cfg.enable {
    # TODO: add systemd service that starts after compositor
    programs.eww = {
      enable = true;
      package = pkg;
      # configDir = config.lib.file.mkOutOfStoreSymlink ./config;
      configDir = ./config; # TODO: make configurable through nix
    };

    home.packages = with pkgs; [
      gnused
      #   pamixer
      #   brightnessctl
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];

    systemd.user.services.eww = {
      Unit = {
        Description = "Eww Daemon";
        # not yet implemented
        # PartOf = ["tray.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        # Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = "${pkg}/bin/eww daemon --no-daemonize";
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
