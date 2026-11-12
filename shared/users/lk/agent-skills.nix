# Agent skills, managed by https://github.com/Kyure-A/agent-skills-nix
# (replaces `npx skills` and the skills tools drop in by themselves).
{
  pkgs,
  inputs,
  ...
}:
let
  llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.agent-skills.homeManagerModules.default ];

  programs.agent-skills = {
    enable = true;

    sources = {
      # our own skills: every folder in ./skills with a SKILL.md is installed (see enableAll)
      custom = {
        path = ./skills;
      };
      obsidian = {
        path = "${inputs.obsidian-skills}";
        subdir = "plugins/obsidian/skills";
      };
      # shipped with the packages, so they match the installed versions
      # herdr-core (hc), what the Herdr app's terminals run in; it points agents at
      # `hc --skill` / `herdr-app --skill`. Not llm-agents.herdr's skill: that one is for
      # the herdr TUI and gives up without HERDR_ENV, which herdr-app never sets.
      herdr-core = {
        path = "${llm-agents.herdr-core}/share/skills/herdr-core";
      };
      terminal-browser = {
        path = "${llm-agents.terminal-browser}/lib/terminal-browser/skills/default";
      };
    };

    skills.enableAll = [ "custom" ];
    skills.enable = [
      "defuddle"
      "json-canvas"
      "obsidian-bases"
      "obsidian-cli"
      "obsidian-markdown"
      "herdr-core"
      "terminal-browser"
    ];

    targets = {
      # shared dir for pi, codex, opencode, ...; fully owned (rsync --delete)
      agents.enable = true;
      # ~/.claude/skills also holds Claude Code's own `synced/`, so per-file
      # home.file links instead of a tree sync that would delete it
      claude = {
        enable = true;
        structure = "link";
        # "link" needs a plain path relative to $HOME (the default ${CLAUDE_CONFIG_DIR:-...} hits a broken regex)
        dest = ".claude/skills";
      };
    };
  };
}
