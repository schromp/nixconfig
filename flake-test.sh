#!/usr/bin/env bash
set -euo pipefail

tempdir=$(mktemp -d /tmp/tmp.nix-updateinfo.XXX)
git clone --reference . . $tempdir
cd $tempdir
nix flake update nixpkgs
nix build ".#nixosConfigurations.$(hostname).config.system.build.toplevel"
nix store diff-closures /run/current-system ./result \
	| awk '/[0-9] →|→ [0-9]/ && !/nixos/' || echo
cd ~-
rm -rf "$tempdir"
