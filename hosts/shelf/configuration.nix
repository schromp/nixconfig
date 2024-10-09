{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../modules
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      root = {
        extraGroups = ["wheel" "docker"];
        shell = pkgs.zsh;
        hashedPassword = "$y$j9T$r/yxsyYRlpXXxy0TPtNRC1$.6pBk8mV/f7AEh0bGHkDEJTFK.7rRissy6WGrTafvH1";
      };
    };
  };

  environment.shells = [pkgs.zsh];

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [vim git];

  services = {
    openssh = {
      enable = true;
    };
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  time.hardwareClockInLocalTime = true;

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };

  system.stateVersion = "24.05";
}
