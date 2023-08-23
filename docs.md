# Defining the configuration
## Flake.nix
- inputs
- the calling function for the hosts

## hosts

### default.nix
- makes the Systems using their respective subfolders

### subfolder
#### hardware-configuration.nix
- self explained
#### configuration.nix
- networking 

## modules
> maybe group them into terminal/desktop/...
- program definitions

## blueprint
- combine multiple modules into one blueprint to be used in hosts
- this is advantagous because i can do the configuration apart from the user

This is what might make it possible

```nix
{ config, lib, home-manager, ... }:

{
  imports = [
    home-manager.nixosModule
    (lib.mkAliasOptionModule ["my"] ["home-manager" "users" "ejg"])
  ];
}
```
