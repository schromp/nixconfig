{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Lennart Koziollek";
    userEmail = "placeholder";
    
    ignores = [
      "*.swp"
      "node_modules"
    ];
  };
}
