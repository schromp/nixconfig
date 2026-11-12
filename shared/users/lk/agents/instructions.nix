# One set of global agent instructions (./AGENTS.md), linked to every agent's own global
# path. There is no global file all agents read (each has its own, and Claude Code reads
# CLAUDE.md), so enable a target per agent you use. Links point at the file in the repo,
# so edits apply without a switch.
#
# pi is not a target: ~/.pi links to shared/users/lk/pi/pi in the repo, so
# pi/pi/agent/AGENTS.md is a git symlink to ./AGENTS.md instead.
{ config, lib, ... }:
let
  cfg = config.programs.agent-instructions;

  defaults = {
    claude = ".claude/CLAUDE.md";
    codex = ".codex/AGENTS.md";
    opencode = ".config/opencode/AGENTS.md";
    amp = ".config/amp/AGENTS.md";
    gemini = ".gemini/GEMINI.md";
  };

  target =
    name: path:
    lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "global instructions for ${name}";
        path = lib.mkOption {
          type = lib.types.str;
          default = path;
          description = "Where ${name} reads its global instructions, relative to $HOME.";
        };
      };
    };
in
{
  options.programs.agent-instructions = {
    source = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.flakePath}/shared/users/lk/agents/AGENTS.md";
      description = "The instructions file (absolute path, linked out of the store so edits are live).";
    };
    targets = lib.mapAttrs (
      name: path:
      lib.mkOption {
        type = target name path;
        default = { };
      }
    ) defaults;
  };

  config.home.file = lib.mapAttrs' (
    _: t: lib.nameValuePair t.path { source = config.lib.file.mkOutOfStoreSymlink cfg.source; }
  ) (lib.filterAttrs (_: t: t.enable) cfg.targets);
}
