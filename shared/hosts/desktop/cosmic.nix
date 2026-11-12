{ pkgs, ... }:
{
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
  };
  environment.systemPackages = [ pkgs.wl-clipboard ];
  environment.sessionVariables = {
    XCURSOR_SIZE = "16";
  };

  # cosmic-store only shows the Applets category with user-scoped remotes
  # (pop-os/cosmic-store#477)
  systemd.user.services.flatpak-cosmic-remotes = {
    description = "Add user flatpak remotes for COSMIC applets";
    wantedBy = [ "default.target" ];
    path = [ pkgs.flatpak ];
    # user units can't wait for network-online.target, so retry instead
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
      RestartSec = 30;
    };
    script = ''
      flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      flatpak remote-add --user --if-not-exists cosmic https://apt.pop-os.org/cosmic/cosmic.flatpakrepo
    '';
  };
}
