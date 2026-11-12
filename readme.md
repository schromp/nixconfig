# My personal nixos configuration

## TODO:

- sops
- niri
- vicanae launcher
- symlink relevant XDG_CONFIG_DIRS

## Custom packages

Packages are exported from the flake; for example, run Colibri Social with `nix run .#packages.x86_64-linux.colibri-social`. The x86_64 package uses preview `0.6.0-spaces.3`; aarch64 remains on `0.6.0-spaces.2` because the newer release has no ARM AppImage. Preview data may reset between releases.
