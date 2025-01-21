{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../presets/hosts/desktop/configuration.nix
  ];

  modules.system.general = {
    monitors = [
      {
        name = "eDP-1";
        resolution = "2880x1800";
        refreshRate = "90";
        scale = "1.5";
        position = "0x0";
      }
      {
        name = "DP-1";
        resolution = "3440x1440";
        refreshRate = "144";
        scale = "1";
        position = "2880x0";
        vrr = true;
      }
    ];
  };

  environment.systemPackages = with pkgs; [steam];

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

  home-manager.users.lk = {
    modules.home.programs.hyprland = {
      sens = "0.1";
      accel = "adaptive";
    };
  };

  system.stateVersion = "23.11";
}
