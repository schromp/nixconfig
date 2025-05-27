{
  config,
  sysConfig,
  ...
}: let
  home = config.modules.home;
in ''
  layout {
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
    ${
    if sysConfig.modules.system.programs.steam.enable
    then ''
      pane {
        command "steam-tui"
      }
    ''
    else ""
  }
    pane command="iamb"
  }
''
