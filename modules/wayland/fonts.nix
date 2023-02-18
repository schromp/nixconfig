{ config, pkgs, ... }:{
  fonts = {
    fonts = with pkgs; [
      material-icons
      material-design-icons
      jetbrains-mono
      ( nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono"];})
    ];

    enableDefaultFonts = false;

    fontconfig = {
      defaultFonts = {
        monospace = [
          "Iosevka Term"
	  "Iosevka Term Nerd Font Complete Mono"
	  "Iosevka Nerd Font"
  	  "Noto Color Emoji"
        ];
        sansSerif = [ "Lexend" "Noto Color Emoji"];
        serif = [ "Noto Serif" "Noto Color Emoji"];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
