{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    # Presets
    ../../presets/hosts/desktop/configuration.nix
  ];

  modules.system = {
    general = {
      nvidia = false;
      monitors = [
        {
          name = "DP-3";
          resolution = "3440x1440";
          refreshRate = "144";
          scale = "1";
          position = "0x0";
          vrr = true;
        }
        {
          name = "HDMI-A-1";
          resolution = "1920x1080";
          refreshRate = "60";
          scale = "1";
          position = "0x1440";
          vrr = false;
        }
      ];
    };
    programs = {
      gamemode.enable = true;
      gamescope.enable = true;
      lutris.enable = true;
      retroarch.enable = true;
      steam.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [];

  # Bootloader stuff
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/nvme0n1";
      useOSProber = true;
    };
  };

  system.stateVersion = "23.11";
}
