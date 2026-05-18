{ inputs, ... }:
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    # inputs.dms.homeModules.niri
  ];

  programs.dank-material-shell = {
    enable = true;

    systemd = {
      enable = true;
    };

    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableVPN = true; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)
    # niri = {
    #   enableSpawn = true;
    #   includes = {
    #     override = true;
    #   };
    # };
  };
}
