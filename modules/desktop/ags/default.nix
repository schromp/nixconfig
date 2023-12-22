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
  ];

  opts = config.modules.user;
  username = opts.username;
in {
  home-manager.users.${username} = {
    # add the home manager module
    imports = [inputs.ags.homeManagerModules.default];

    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      # configDir = ../ags;

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
        ExecStart = "${inputs.ags.packages.${config.modules.system.architecture}.default}/bin/ags";
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
