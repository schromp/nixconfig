# herdr-nvim (https://github.com/ChmaraX/herdr-nvim): nvim sidebar for the Herdr app.
# Output is laid out like the runtime its installer writes to
# ~/.local/share/herdr-nvim/app/<stamp>: bin/herdr-nvim + lua/ + plugin/.
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zlib,
  libgit2,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "herdr-nvim";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "ChmaraX";
    repo = "herdr-nvim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/026mNSbhZIAMJeNdSsbi9vhUuQEfdjqI99QzKAHW6w=";
  };

  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libgit2
    zlib
  ];

  # tests drive a real nvim and herdr
  doCheck = false;

  # The app mods, ready to link into ~/.config/herdr-app/mods: what
  # herdr-app/install.sh copies there, with its wrapper pointing at this package.
  postInstall = ''
    cp -r lua plugin $out/
    install -Dm755 herdr-app/install-nvim.sh $out/bin/install-nvim.sh

    mods=$out/share/herdr-nvim/mods
    mkdir -p $mods
    cp -r herdr-app/mods/herdr-nvim herdr-app/mods/herdr-nvim-header $mods/
    echo "# Written by herdr-nvim's herdr-app/install.sh" > $mods/herdr-nvim-header/.herdr-nvim
    mkdir -p $mods/herdr-nvim/bin
    cat > $mods/herdr-nvim/bin/herdr-nvim <<EOF
    #!/bin/sh
    # Written by herdr-nvim's herdr-app/install.sh (the Nix equivalent)
    export HERDR_NVIM_HOST=app
    export HERDR_APP_HOME="\''${HERDR_APP_HOME:-\$HOME/.config/herdr-app}"
    export HERDR_NVIM_SELF="\$HERDR_APP_HOME/mods/herdr-nvim/bin/herdr-nvim"
    export HERDR_NVIM_PLUGIN_ROOT='$out'
    export HERDR_APP_BIN="\''${HERDR_APP_BIN:-\$(command -v herdr-app)}"
    exec '$out/bin/herdr-nvim' "\$@"
    EOF
    chmod +x $mods/herdr-nvim/bin/herdr-nvim
  '';

  meta = {
    description = "Neovim sidebar for the Herdr app";
    homepage = "https://github.com/ChmaraX/herdr-nvim";
    license = lib.licenses.mit;
    mainProgram = "herdr-nvim";
  };
})
