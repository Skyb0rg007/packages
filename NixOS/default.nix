{
  pkgs ? import <nixpkgs> { config.allowUnfree = true; },
  lib ? pkgs.lib,
  ...
}:
let
  nixosModules = import ./modules/nixos;
  nixosTests = import ./tests/all-tests.nix {
    inherit pkgs;
    modules = nixosModules;
    packages = { inherit cascade; };
  };
  callPackage = lib.callPackageWith (pkgs // { inherit nixosTests; });
  callPython3Package = lib.callPackageWith (pkgs // pkgs.python3Packages // { inherit nixosTests; });
  mlkit = callPackage ./pkgs/mlkit { };
  cascade = callPackage ./pkgs/cascade { };
in
{
  inherit nixosModules;

  keylime = callPackage ./pkgs/keylime { };
  rust-keylime = callPackage ./pkgs/rust-keylime { };
  mxc = callPackage ./pkgs/mxc { };
  inherit cascade;
  cascade-hsm-bridge = callPackage ./pkgs/cascade-hsm-bridge { };
  sbuild = callPackage ./pkgs/sbuild { };
  rsbinder-tools = callPackage ./pkgs/rsbinder-tools { };
  run0-wrappers = callPackage ./pkgs/run0-wrappers { };
  masque-go = callPackage ./pkgs/masque-go { };
  image-builder = callPackage ./pkgs/image-builder { };

  # Lars Wirzenius's Packages
  ambient-build-vm = callPackage ./pkgs/ambient-build-vm { };
  ambient-ci = callPackage ./pkgs/ambient-ci { };
  radicle-ci-ambient = callPackage ./pkgs/radicle-ci-ambient { };
  subplot = callPackage ./pkgs/subplot { };
  vmdb2 = callPython3Package ./pkgs/vmdb2 { };

  anemoi = callPython3Package ./pkgs/anemoi { };
  ascsaver = callPackage ./pkgs/ascsaver { };
  inherit mlkit;
  barry = callPackage ./pkgs/barry { inherit mlkit; };
  smltojs = callPackage ./pkgs/smltojs { inherit mlkit; };
  bencher = callPackage ./pkgs/bencher { };
  browsertrix-crawler = callPackage ./pkgs/browsertrix-crawler { };
  cdash = callPackage ./pkgs/cdash { };
  porkbun-ddns = callPython3Package ./pkgs/porkbun-ddns { };
  reddio = callPackage ./pkgs/reddio { };
  tmux-notify = callPackage ./pkgs/tmux-notify { };
  tubearchivist = callPackage ./pkgs/tubearchivist { };
}
