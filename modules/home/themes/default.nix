{ config, inputs, pkgs, ... }: {
  
  gtk = {
    enable = false;
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata Modern Ice";
    cursorTheme.size = 16;
    theme = {
      name = "Catppuccin-Macchiato-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        variant = "macchiato";
      };
    };
  };
}
