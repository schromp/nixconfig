{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  dependencies = with pkgs; [
    bash
    coreutils
    sassc
    dunst
  ];

  opts = config.modules.user;
  username = opts.username;
  cfg = config.modules.programs.ags;
in {
  options.modules.programs.ags = {
    enable = mkEnableOption "Enable ags";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      # add the home manager module
      imports = [inputs.ags.homeManagerModules.default];

      programs.ags = {
        enable = true;
        # packages to add to gjs's runtime
        # extraPackages = [pkgs.libsoup_3];
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
  };
}
