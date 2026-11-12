# Global agent setup: instructions (AGENTS.md / CLAUDE.md) for each agent in use.
# Skills live in ../agent-skills.nix.
{
  imports = [ ./instructions.nix ];

  programs.agent-instructions.targets = {
    claude.enable = true;
    # codex.enable = true;
    # opencode.enable = true;
    # amp.enable = true;
  };
}
