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
    lxqt.lxqt-policykit
    imagemagick
    rnote
    evince
    spotify
    vlc
    gimp
    nautilus
    chromium
    proton-pass
    proton-vpn
    protonmail-desktop
    # bambu-studio
    # orca-slicer
    alsa-utils # TODO: why?
    p7zip
    nix-prefetch-git
    freecad
    slack
    pavucontrol
    pa_applet
    powertop
    netbird
    openlinkhub
    openrgb
    virt-viewer
  ];
}
