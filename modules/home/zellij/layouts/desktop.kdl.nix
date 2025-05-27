{
  config,
  sysConfig,
  pkgs,
  lib,
  ...
}: let
  home = config.modules.home;
in ''
  layout {
    tab {
      ${
    if home.programs.yazi.enable
    then ''
      pane {
        command "yazi"
        cwd "/home/${config.home.username}"
      }
    ''
    else ""
  }
      pane size=1 borderless=true {
          plugin location="zellij:compact-bar"
      }
    }
    tab {
      ${
    if sysConfig.modules.system.programs.steam.enable
    then ''
      pane {
        command "${lib.getExe pkgs.steam-tui}"
      }
    ''
    else ""
  }
      pane size=1 borderless=true {
          plugin location="zellij:compact-bar"
      }
    }
    tab {
      pane command="iamb"
      pane size=1 borderless=true {
          plugin location="zellij:compact-bar"
      }
    }
  }
''
