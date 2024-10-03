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

    # ...
}
```

You can use the packages with `skye-packages.packages.package-name`,
or can import them all with `skye-packages.overlays.default`:

```nix
{
    nixpkgs.overlays = [ skye-packages.overlays.default ];

    # ...
}
```

### Packages

- `smlnj`: SML/NJ
  - Version 110.99.6
  - GitHub: https://github.com/smlnj/legacy

- `smlnj-dev`: SML/NJ development
  - Version 2024.2
  - GitHub: https://github.com/smlnj/smlnj

- `mlton-dev`: MLton
  - Version 20240809
  - GitHub: https://github.com/MLton/mlton

- `porkbun-ddns`: Porkbun DDNS
  - GitHub: https://github.com/mietzen/porkbun-ddns

- `tmux-notify`: Tmux Notify
  - GitHub: https://github.com

- `ascsaver`: ASCII screen saver
  - GitLab: https://gitlab.com/mezantrop/ascsaver

- `receipt-wrangler`: Receipt Wrangler
  - GitHub: https://github.com/Receipt-Wrangler/receipt-wrangler-api

- `receipt-wrangler-desktop`: Receipt Wrangler Desktop
  - GitHub: https://github.com/Receipt-Wrangler/receipt-wrangler-desktop

#### 
