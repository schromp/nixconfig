{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    # Presets
    ../../shared/hosts/desktop/configuration.nix
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
          position = "3440x0";
          transform = "0";
          vrr = false;
        }
      ];
    };
    programs = {
      bottles.enable = false;
      gamemode.enable = true;
      gamescope.enable = true;
      lutris.enable = true;
      retroarch.enable = true;
      steam.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    renoise
    supercollider
    obs-studio
    r2modman
  ];

  # Bootloader stuff
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/nvme0n1";
      useOSProber = true;
    };
  };

  home-manager.users.lk = {
    modules.home.programs.hyprland = {
      sens = "-0.2";
      accel = "flat";
    };
  };

  system.stateVersion = "23.11";
}
