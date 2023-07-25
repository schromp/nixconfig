{pkgs, ...}: let
  username = config.user.username;
in {
  home-manager.users.${username} = {
    home.pointerCursor.package = pkgs.bibata-cursors;
    home.pointerCursor.name = "Bibata-Modern-Ice";
    home.pointerCursor.size = 24;

    gtk = {
      enable = true;
      cursorTheme.package = pkgs.bibata-cursors;
      cursorTheme.name = "Bibata-Modern-Ice";
      cursorTheme.size = 24;
      theme = {
        name = "Catppuccin-Macchiato-Standard-Pink-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["pink"];
          variant = "macchiato";
        };
      };
    };
  };
}
