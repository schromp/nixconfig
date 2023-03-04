{ config, pkgs, ... }: {
  fonts = {
    fonts = with pkgs; [
      material-icons
      material-design-icons
      (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })
    ];

    enableDefaultFonts = false;

    fontconfig = {
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
          "Iosevka Term"
          "Iosevka Term Nerd Font Complete Mono"
          "Iosevka Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = [ "Lexend" "Noto Color Emoji" ];
        serif = [ "Noto Serif" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
