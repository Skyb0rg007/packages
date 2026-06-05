{
  pkgs ? import <nixpkgs> { config.allowUnfree = true; },
  ...
}:
rec {
  nixosModules = import ./modules/nixos;

  keylime = pkgs.callPackage ./pkgs/keylime { };
  rust-keylime = pkgs.callPackage ./pkgs/rust-keylime { };
  mxc = pkgs.callPackage ./pkgs/mxc { };
  cascade = pkgs.callPackage ./pkgs/cascade { };
  cascade-hsm-bridge = pkgs.callPackage ./pkgs/cascade-hsm-bridge { };
  sbuild = pkgs.callPackage ./pkgs/sbuild { };
  rsbinder-tools = pkgs.callPackage ./pkgs/rsbinder-tools { };
  run0-wrappers = pkgs.callPackage ./pkgs/run0-wrappers { };
  masque-go = pkgs.callPackage ./pkgs/masque-go { };
  image-builder = pkgs.callPackage ./pkgs/image-builder { };

  # Lars Wirzenius's Packages
  ambient-build-vm = pkgs.callPackage ./pkgs/ambient-build-vm { };
  ambient-ci = pkgs.callPackage ./pkgs/ambient-ci { };
  radicle-ci-ambient = pkgs.callPackage ./pkgs/radicle-ci-ambient { };
  subplot = pkgs.callPackage ./pkgs/subplot { };
  vmdb2 = pkgs.python3Packages.callPackage ./pkgs/vmdb2 { };

  anemoi = pkgs.python3Packages.callPackage ./pkgs/anemoi { };
  ascsaver = pkgs.callPackage ./pkgs/ascsaver { };
  mlkit = pkgs.callPackage ./pkgs/mlkit { };
  barry = pkgs.callPackage ./pkgs/barry { inherit mlkit; };
  smltojs = pkgs.callPackage ./pkgs/smltojs { inherit mlkit; };
  bencher = pkgs.callPackage ./pkgs/bencher { };
  browsertrix-crawler = pkgs.callPackage ./pkgs/browsertrix-crawler { };
  cdash = pkgs.callPackage ./pkgs/cdash { };
  porkbun-ddns = pkgs.python3Packages.callPackage ./pkgs/porkbun-ddns { };
  reddio = pkgs.callPackage ./pkgs/reddio { };
  tmux-notify = pkgs.callPackage ./pkgs/tmux-notify { };
  tubearchivist = pkgs.callPackage ./pkgs/tubearchivist { };
}
