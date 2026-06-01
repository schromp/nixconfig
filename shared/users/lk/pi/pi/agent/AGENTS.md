# Environment: NixOS

You are running on **NixOS** (Linux). Use Nix flakes for all development environments.

## Project Setup Workflow

When working on a project, check for tooling in this order:

1. **Nix Flake** (`flake.nix` in project root)
   - If present: `nix develop` (or `nix develop --profile .#default` for persistence)
   - Run commands via `nix develop -c bash -c "..."` or work inside the shell
   - Never assume npm/node/python/etc. are globally available

2. **Devshell (direnv)** 
   - Check for `.envrc` — if present, direnv should auto-enter the environment
   - Check for `default.nix` or legacy `shell.nix`

3. **No Nix files found?**
   - Look at what the project needs (check `package.json`, `Makefile`, etc.)
   - Use `nix-shell -p` for one-off needs, or suggest adding a `flake.nix`
   - Still prefer nix-managed environments over system packages

## Nix Commands

```bash
# Dev environments
nix develop                          # enter flake devShell
nix develop -c cmd args             # run command directly
nix develop --profile .#default     # persistent profile

# Building
nix build .#<attr>                  # build specific output
nix flake check                      # run all checks

# Utilities
nix flake update                     # update lock file
direnv allow                         # authorize direnv for project
```

## Project Indicators

| File | Tool |
|------|------|
| `flake.nix` | Nix flake (use `nix develop`) |
| `.envrc` | Direnv (auto-enters shell) |
| `default.nix` | Legacy nix |
| `package.json` | Node.js (prefer nix env) |
| `Makefile` | Traditional build |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `*.cabal`, `stack.yaml` | Haskell |

## Key Paths

- Home: `~` = `/home/lk`
- Repos: `~/repos`