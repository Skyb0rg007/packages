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

### Cachix substituter

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
  - [anemoi.nix](./NixOS/pkgs/anemoi.nix)
  - GitHub: https://github.com/dayt0n/anemoi

- `ascsaver`: ASCII screen saver
  - [ascsaver.nix](./NixOS/pkgs/ascsaver.nix)
  - GitLab: https://gitlab.com/mezantrop/ascsaver

- `smlnj-dev`: SML/NJ development
  - [smlnj-dev.nix](./NixOS/pkgs/smlnj-dev.nix)
  - GitHub: https://github.com/smlnj/smlnj

- `mlton`: MLton
  - [mlton.nix](./NixOS/pkgs/mlton.nix)
  - GitHub: https://github.com/MLton/mlton

- `porkbun-ddns`: Porkbun DDNS
  - [porkbun-ddns.nix](./NixOS/pkgs/porkbun-ddns.nix)
  - GitHub: https://github.com/mietzen/porkbun-ddns

- `tmux-notify`: Tmux Notify
  - [tmux-notify.nix](./NixOS/pkgs/tmux-notify.nix)
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

## Ubuntu/Debian

I setup an APT repository hosted on GitHub Pages at https://apt.soss.website/.
The [README.html](https://apt.soss.website/README.html) has an installation
guide.

Note: I intentionally do not clone the source code in this repo.
To build, use the `build.sh` script which uses `uscan` to download the
sources from upstream.

### Packages

- `skyenet-archive-keyring`
  - [skyenet-archive-keyring/](./Debian/pkgs/skyenet-archive-keyring)
  - This package installs the gpg + apt sources files so that a user can
    install packages from the Skyenet repo through the `apt` command.
    Installing this is the entire "bootstrap" path.

- `golang-github-biezhi-gorm-paginator`
  - [golang-github-biezhi-gorm-paginator](./Debian/pkgs/golang-github-biezhi-gorm-paginator)
  - Dependency for pwngrid
  - GitHub: https://github.com/biezhi/gorm-paginator

### In-Progress

- `pwngrid`
  - GitHub: https://github.com/jayofelony/pwngrid

- `pwnagotchi`
  - GitHub: https://github.com/jayofelony/pwnagotchi

- `smlnj`
  - GitHub: https://github.com/smlnj/smlnj
