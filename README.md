# Skyenet packages
Repo for all different packages

## NixOS

This subdirectory is a Nix flake.

Import with

```nix
{
    inputs.skyenet.url = "github:Skyb0rg007/packages.git?dir=NixOS";
    # If you're also depending on nixpkgs
    inputs.skyenet.inputs.nixpkgs.follows = "nixpkgs";
    # If you're also depending on cachix's git-hooks package
    inputs.skyenet.inputs.git-hooks.follows = "git-hooks";

    # ...
}
```

You can then the packages with `skyenet.packages.${system}.package-name`.
For `NixOS` or `home-manager` modules, you can pass extra arguments through
the `specialArgs` or `extraSpecialArgs` inputs respectively.

## Cachix substituter

Instead of building the packages on your machine, you can download
pre-built derivations courtesy of [Cachix](https://cachix.org).
Add the following to your `nix.conf`:

```conf
extra-substituters = https://skyenet.cachix.org
extra-trusted-public-keys = skyenet.cachix.org-1:Pf1Kzvduw4vFW0jGH3Vvaxkv8RYk2EK5LyPzhpYBI5s=
```

Note: the `extra-` prefix just means the line won't override previous configuration.

### Packages

- `anemoi`: Least-privilege Dynamic DNS
  - GitHub: https://github.com/dayt0n/anemoi

- `ascsaver`: ASCII screen saver
  - GitLab: https://gitlab.com/mezantrop/ascsaver

- `smlnj-dev`: SML/NJ development
  - Version 2024.2
  - GitHub: https://github.com/smlnj/smlnj

- `mlton`: MLton
  - Version 20240809
  - GitHub: https://github.com/MLton/mlton

- `porkbun-ddns`: Porkbun DDNS
  - GitHub: https://github.com/mietzen/porkbun-ddns

- `tmux-notify`: Tmux Notify
  - GitHub: https://github.com/rickstaa/tmux-notify

### In-Progress / Stalled

- `recutils`
  - The version on nixpkgs doesn't compile on Darwin.
    I was trying to change things so this would be fixed
- `reddio`
- `cdash`
- `tubearchivist`
- `archivebox`
- `paperless-ai`

#### 
