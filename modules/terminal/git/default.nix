{lib, ...}:
with lib; let
  cfg = options.modules.terminal.git;
in {
  cfg.enable = mkEnableOption "Enable git + lazygit";

  config.git = mkIf cfg.enable {
    programs.git = {
      enable = true;

      # TODO: move this into userspace
      userName = "Lennart Koziollek";
      userEmail = "lennart.koziollek@stud.uni-due.de";
    };

    home.packages = with pkgs; [
      lazygit
    ];

    programs.gnupg.agent.enableSSHSupport = true;
  };
}
