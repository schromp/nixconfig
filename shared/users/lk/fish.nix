{...}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      "lg" = "lazygit";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
