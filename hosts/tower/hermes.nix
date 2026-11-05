# Hermes agent on tower, as a native system service (NixOS module from the
# hermes-agent flake, not container mode).
#
# - The agent runs as the system user `hermes` with its state in /var/lib/hermes.
#   It cannot read /home/lk (mode 700). Only the files under /var/lib/hermes are
#   its own.
# - `hermes serve` listens on 127.0.0.1:9119 only. `hermes-desktop-tower`
#   (installed below) connects to it with a shared session token instead of
#   starting its own backend as lk.
# - Plain `hermes-desktop` uses the gateway saved in the app. Don't set
#   HERMES_DESKTOP_REMOTE_URL for it: that locks the gateway settings and forces
#   token auth, which rules out signing in to an OIDC gateway.
# - The install is "managed": Hermes refuses its own plugin installs and setup
#   wizard. Plugins go into `extraPlugins` / `extraPythonPackages` below.
#   Model, provider and other settings can still be changed in the desktop app.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;

  # Must match the hermes-agent tag in flake.nix. The upstream flake can't see
  # git tags and would stamp 0.0.0, which fails plugins' `requires_hermes` check.
  hermesVersion = "0.22.5";
  hermesPackage = inputs.hermes-agent.packages.${system}.default.override {
    version = hermesVersion;
  };

  backendUrl = "http://127.0.0.1:9119";

  # Shared session token between the backend (user hermes) and the desktop app
  # (user lk). Regenerated at every boot; /run is tmpfs.
  tokenGroup = "hermes-desktop";
  tokenDir = "/run/hermes-desktop";
  tokenFile = "${tokenDir}/token";

  hermesDesktop = hermesPackage.hermesDesktop;

  # Read the token at every start, never bake it into the store. Without the
  # token the app falls back to its own (broken, read-only) local backend.
  hermesDesktopTower = pkgs.writeShellScriptBin "hermes-desktop-tower" ''
    if [ ! -r ${tokenFile} ]; then
      echo "hermes-desktop-tower: cannot read ${tokenFile} (member of ${tokenGroup}? log out and in once)" >&2
      exit 1
    fi
    export HERMES_DESKTOP_REMOTE_URL=${backendUrl}
    HERMES_DESKTOP_REMOTE_TOKEN="$(${pkgs.coreutils}/bin/tr -d '\r\n' < ${tokenFile})"
    export HERMES_DESKTOP_REMOTE_TOKEN
    exec ${hermesDesktop}/bin/hermes-desktop "$@"
  '';
in
{
  imports = [ inputs.hermes-agent.nixosModules.default ];

  services.hermes-agent = {
    enable = true;
    package = hermesPackage;

    backend = {
      mode = "serve"; # "dashboard" would add the browser UI on the same port
      host = "127.0.0.1";
      port = 9119;
      sessionTokenFile = tokenFile;
    };

    # API keys from the existing sops secrets (shared/hosts/desktop/sops.nix)
    environmentFiles = [ config.sops.templates."hermes.env".path ];

    # Plugins, declaratively. Directory plugins need plugin.yaml + __init__.py:
    # extraPlugins = [ (pkgs.fetchFromGitHub { owner = ...; repo = ...; rev = ...; hash = ...; }) ];
    # Python deps / pip-style plugins (built with hermes' own Python):
    # extraPythonPackages = [ ];
  };

  sops.templates."hermes.env".content = ''
    OPENROUTER_API_KEY=${config.sops.placeholder."openrouter-api-key"}
    OPENCODE_GO_API_KEY=${config.sops.placeholder."opencodego-api-key"}
  '';

  # --- desktop <-> backend token ------------------------------------------------
  users.groups.${tokenGroup}.members = [
    "lk"
    config.services.hermes-agent.user
  ];

  systemd.services.hermes-desktop-token = {
    description = "Session token shared by hermes-backend and Hermes Desktop";
    wantedBy = [ "multi-user.target" ];
    before = [ "hermes-backend.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      install -d -m 0750 -o root -g ${tokenGroup} ${tokenDir}
      if [ ! -s ${tokenFile} ]; then
        (umask 0137; ${pkgs.openssl}/bin/openssl rand -hex 32 > ${tokenFile})
      fi
      chown root:${tokenGroup} ${tokenFile}
      chmod 0640 ${tokenFile}
    '';
  };

  systemd.services.hermes-backend = {
    requires = [ "hermes-desktop-token.service" ];
    after = [ "hermes-desktop-token.service" ];
  };

  environment.systemPackages = [
    hermesDesktop
    hermesDesktopTower
  ];
}
