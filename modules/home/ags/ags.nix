{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  dependencies = with pkgs; [
    bash
    coreutils
    sassc
    dunst
    pipewire
  ];
  cfg = config.modules.home.programs.ags;
in {
  options.modules.home.programs.ags = {
    enable = lib.mkEnableOption "Enable ags";
  };

  imports = [inputs.ags.homeManagerModules.default];

  config = lib.mkIf cfg.enable {
    # add the home manager module

    programs.ags = {
      enable = true;
      # packages to add to gjs's runtime
      extraPackages = [pkgs.libsoup_3 pkgs.alsa-utils];
    };

    systemd.user.services.ags = {
      Unit = {
        Description = "Aylur's Gtk Shell";
        PartOf = [
          "tray.target"
          "graphical-session.target"
        ];
      };
      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = "${inputs.ags.packages.${config.modules.system.architecture}.default}/bin/ags --config ${config.modules.user.repoDirectory}/modules/ags/config/config.js";
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
