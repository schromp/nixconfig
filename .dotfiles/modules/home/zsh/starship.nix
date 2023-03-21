{ config, inputs, ... }: {

  programs.starship = {
    enable = true;
    settings = {
      format = ''
        (bold green)$directory$rust$package
        [└─>](bold green)
      '';

      character = {
        success_symbol = "[➜](bold green)";
      };
    };
  };
}
