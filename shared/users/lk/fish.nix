{...}: {
  programs.fish = {
    enable = true;
    generateCompletions = true;
    shellAliases = {
      "lg" = "lazygit";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
