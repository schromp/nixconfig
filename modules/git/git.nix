{
  lib,
  config,
  pkgs,
  ...
}: let
  username = config.modules.user.username;
  cfg = config.modules.programs.git;
in {
  options.modules.programs.git = {
    enable = lib.mkEnableOption "Enable git";
    lazygit = lib.mkEnableOption "Enable lazygit";
  };

  home = {
    config = lib.mkIf cfg.enable (lib.mkMerge [
      {
        programs.git.enable = true;
        home-manager.users.${username} = {
          programs = {
            git = {
              enable = true;
              lfs = {
                enable = true;
              };

              # TODO: move this into userspace
              userName = "Lennart Koziollek";
              userEmail = "lennart.koziollek@stud.uni-due.de";
              extraConfig = {
                init.defaultBranch = "main";
              };
            };
            gh = {
              enable = true;
            };
          };
        };
      }
      (lib.mkIf cfg.lazygit {
        home-manager.users.${username} = {
          home.packages = with pkgs; [
            lazygit
          ];
        };
      })

      # programs.gnupg.agent.enableSSHSupport = true;
    ]);
  };
}
