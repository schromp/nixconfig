# Colorschemes

## How it works

- One directory per supported program
- Define colorscheme inside the directory of program
- One root derivation will pull everything together into one directory
- Use external symlink manager to link the files to the correct places
- base16 as fallback for programs that dont have a configuration for a specific colorscheme

## Commands

`nix eval --file colorschemes/default.nix --json`
