{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.system.programs.shpool = {
    enable = lib.mkEnableOption "Enable shpool daemon";
  };

  config = lib.mkIf config.modules.system.programs.shpool.enable {
    environment.systemPackages = with pkgs; [
      shpool
    ];

    systemd.sockets.shpool = {
      description = "Shpool Shell Session Pooler";
      listenStreams = ["%t/shpool/shpool.socket"];
      socketConfig.SocketMode = "0600";
      wantedBy = ["sockets.target"];
    };

    systemd.services.shpool = {
      description = "Shpool - Shell Session Pool";
      requires = ["shpool.socket"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.shpool}/bin/shpool daemon";
        KillMode = "mixed";
        TimeoutStopSec = "2s";
        SendSIGHUP = "yes";
        Environment = "XDG_RUNTIME_DIR=/run/shpool";
      };
      wantedBy = ["default.target"];
    };
  };
}
