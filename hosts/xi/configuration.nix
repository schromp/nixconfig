{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../presets/desktop/configuration.nix
  ];

  # start services
  services = {
    upower.enable = true;
    tlp = {
      enable = true;
    };
  };

  programs.nm-applet.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.11";
}
