{
  inputs,
  home-manager,
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [vim docker];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users."lennart.koziollek" = {
    description = "test";
    home = "/Users/lennart.koziollek";
  };

  # inputs.home-manager.useGlobalPkgs = true;
  # inputs.home-manager.useUserPackages = true;
  home-manager.users."lennart.koziollek" = {
    home.stateVersion = "24.05";
    home.username = "lennart.koziollek";
    home.homeDirectory = "/Users/lennart.koziollek";

    home.packages = with pkgs; [
      # openfortivpn
      lazygit
      htop
      tldr
      jira-cli-go

      spotify
      raycast
      unnaturalscrollwheels

      yaml-language-server
      colima
      devpod
      php83Packages.composer
      php83
      nodejs_18
      openssh
    ];
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono" "Iosevka" "FiraCode"];})
      cascadia-code
    ];
  };

  homebrew = {
    enable = true;

    brews = [
      "salt-lint"
    ];
    casks = [
      "michaelroosz/ssh/libsk-libfido2-install"
      "whatsapp"
      "nikitabobko/tap/aerospace"
      "orbstack"
    ];
    taps = [];
  };

  # System settings
  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      static-only = false;
    };
    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
      QuitMenuItem = true;
    };
    NSGlobalDomain.KeyRepeat = 1;
  };

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle when changing macos options
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  security.pam.enableSudoTouchIdAuth = true;
}
