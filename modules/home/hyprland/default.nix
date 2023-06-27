{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland.nvidia = mkEnableOption "Enable Nvidia Support for Hyprland-Home-Manager Module";

  config = {
    home.packages = with pkgs; [
      brightnessctl # change this to light probably
      wl-clipboard
      swaylock-effects
      swayidle
      libnotify
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      systemdIntegration = true;
      nvidiaPatches = true;
      extraConfig = builtins.readFile ./hyprland.conf;
    };
    xdg.configFile."hypr/hyprpaper.conf".text = builtins.readFile ./hyprpaper.conf;

    services.dunst.enable = true;
  };


  # umlaute into keyboard
  xdg.configFile."xkb/symbols/us-german-umlaut".text = ''
    default partial alphanumeric_keys
    xkb_symbols "basic" {
      include "us(altgr-intl)"
      include "level3(caps_switch)"
      name[Group1] = "English (US, international with German umlaut)";
      key <AD03> { [ e, E, EuroSign, cent ] };
      key <AD07> { [ u, U, udiaeresis, Udiaeresis ] };
      key <AD09> { [ o, O, odiaeresis, Odiaeresis ] };
      key <AC01> { [ a, A, adiaeresis, Adiaeresis ] };
      key <AC02> { [ s, S, ssharp ] };
    };

  '';
}
