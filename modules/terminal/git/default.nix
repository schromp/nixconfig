{lib, config, pkgs, ...}:
with lib; let
  cfg = config.modules.terminal.git;
in {
  options.modules.terminal.git.enable = mkEnableOption "Enable git + lazygit";

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      # TODO: move this into userspace
      userName = "Lennart Koziollek";
      userEmail = "lennart.koziollek@stud.uni-due.de";
    };

    home.packages = with pkgs; [
      lazygit
    ];

    # programs.gnupg.agent.enableSSHSupport = true;
  };
}
