{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Lennart Koziollek";
    userEmail = "lennart.koziollek@stud.uni-due.de";
    
    ignores = [
      "*.swp"
      "node_modules"
    ];
  };
  programs.gnupg.agent.enableSSHSupport = true;
}
