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
}
