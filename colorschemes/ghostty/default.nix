{
  supportedMetaAttributes = [ "opacity" ];
  directory = "xdgConfig/ghostty"; # TODO: function to get xdgConfig
  activationScript = "pkill -SIGUSR2 ghostty";
}
