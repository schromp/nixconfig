# clickhousectl, the ClickHouse CLI (local servers + ClickHouse Cloud). Not in nixpkgs;
# the ClickHouse infra-* agent skills need it and otherwise tell the agent to `curl | sh`
# it into ~/.local/bin. Upstream ships static binaries (musl on Linux).
{
  fetchurl,
  lib,
  stdenvNoCC,
}:
let
  version = "0.5.1";
  targets = {
    x86_64-linux = {
      triple = "x86_64-unknown-linux-musl";
      hash = "sha256-JiY9aAVCBw/9X4NZkrVcdXl+7LsLd1cI8QG5oMpJKnM=";
    };
    aarch64-linux = {
      triple = "aarch64-unknown-linux-musl";
      hash = "sha256-CmxfZf8/ZO2qTQ8A/dNnESBb72DtL9PIu+iyO/AO7Jg=";
    };
    x86_64-darwin = {
      triple = "x86_64-apple-darwin";
      hash = "sha256-nl9X+8uGE5NXU4nLi3xkwRhDIZTC1vqH/LTzNyEpdYE=";
    };
    aarch64-darwin = {
      triple = "aarch64-apple-darwin";
      hash = "sha256-DTjFcc+u1ZRlqbAMoCh3+N/jjo/A5N5sqS9SL3RAaNk=";
    };
  };
  system = stdenvNoCC.hostPlatform.system;
  target = targets.${system} or (throw "clickhousectl: unsupported system ${system}");
in
stdenvNoCC.mkDerivation {
  pname = "clickhousectl";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ClickHouse/clickhousectl/releases/download/v${version}/clickhousectl-${target.triple}-v${version}.tar.gz";
    inherit (target) hash;
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 clickhousectl $out/bin/clickhousectl
    ln -s clickhousectl $out/bin/chctl
    runHook postInstall
  '';

  meta = {
    description = "CLI for ClickHouse: local servers and ClickHouse Cloud";
    homepage = "https://github.com/ClickHouse/clickhousectl";
    license = lib.licenses.asl20;
    mainProgram = "clickhousectl";
    platforms = builtins.attrNames targets;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
