# packages
Repo for all different packages

## NixOS

This subdirectory is a Nix flake

Import with

```nix
{
    inputs.skye-packages.url = "github:Skyb0rg007/packages.git?dir=NixOS";
    # If you're also depending on nixpkgs
    inputs.skye-packages.inputs.nixpkgs.follows = "nixpkgs";
    # If you're also depending on cachix's git-hooks package
    inputs.skye-packages.inputs.git-hooks.follows = "git-hooks";
}
```
