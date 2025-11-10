{...}: {
  programs.fish = {
    enable = true;
    generateCompletions = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
