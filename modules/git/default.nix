{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  username = config.modules.user.username;
  cfg = config.modules.programs.git;
in {
  options.modules.programs.git = {
    enable = mkEnableOption "Enable git";
    lazygit = mkEnableOption "Enable lazygit";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.git.enable = true;
      home-manager.users.${username} = {
        programs = {
          git = {
            enable = true;

            # TODO: move this into userspace
            userName = "Lennart Koziollek";
            userEmail = "lennart.koziollek@stud.uni-due.de";
            extraConfig = {
              init.defaultBranch = "main";
            };

            lfs.enable = true;
          };
          gh = {
            enable = true;
          };
        };
      };
    }
    (mkIf cfg.lazygit {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          lazygit
        ];
      };
    })

    # programs.gnupg.agent.enableSSHSupport = true;
  ]);
}
