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
      obsidian = {
        path = "${inputs.obsidian-skills}";
        subdir = "plugins/obsidian/skills";
      };
      vercel = {
        path = "${inputs.vercel-skills}";
        subdir = "skills";
      };
      # shipped with the packages, so they match the installed versions
      herdr = {
        path = "${llm-agents.herdr}/share/skills/herdr";
      };
      terminal-browser = {
        path = "${llm-agents.terminal-browser}/lib/terminal-browser/skills/default";
      };
    };

    skills.enable = [
      "defuddle"
      "json-canvas"
      "obsidian-bases"
      "obsidian-cli"
      "obsidian-markdown"
      "find-skills"
      "herdr"
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
