{ pkgs, lib, config, inputs, ... }:
{
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

  # TODO start the services i need
  services.dunst.enable = true;
}
