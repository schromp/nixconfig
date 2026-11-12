{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sops
    coreutils
    lsof
    curl
    git
    vim
    btop
    ncdu
    lxqt.lxqt-policykit
    imagemagick
    alsa-utils # TODO: why?
    p7zip
    nix-prefetch-git
    pavucontrol
    powertop
    netbird
    distrobox
  ];
}
