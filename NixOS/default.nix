{
  pkgs ? import <nixpkgs> { config.allowUnfree = true; },
  ...
}:
rec {
  example-test = pkgs.testers.runNixOSTest {
    imports = [ ./tests/example.nix ];
  };

  keylime = pkgs.callPackage ./pkgs/keylime.nix { };
  rust-keylime = pkgs.callPackage ./pkgs/rust-keylime.nix { };
  mxc = pkgs.callPackage ./pkgs/mxc.nix { };
  cascade = pkgs.callPackage ./pkgs/cascade.nix { };
  sbuild = pkgs.callPackage ./pkgs/sbuild.nix { };
  rsbinder-tools = pkgs.callPackage ./pkgs/rsbinder-tools.nix { };
  run0-wrappers = pkgs.callPackage ./pkgs/run0-wrappers.nix { };
  masque-go = pkgs.callPackage ./pkgs/masque-go.nix { };
  image-builder = pkgs.callPackage ./pkgs/image-builder.nix { };

  # Lars Wirzenius's Packages
  ambient-build-vm = pkgs.callPackage ./pkgs/ambient-build-vm.nix { };
  ambient-ci = pkgs.callPackage ./pkgs/ambient-ci.nix { };
  radicle-ci-ambient = pkgs.callPackage ./pkgs/radicle-ci-ambient.nix { };
  subplot = pkgs.callPackage ./pkgs/subplot.nix { };
  vmdb2 = pkgs.callPackage ./pkgs/vmdb2.nix { };

  anemoi = pkgs.callPackage ./pkgs/anemoi.nix { };
  ascsaver = pkgs.callPackage ./pkgs/ascsaver.nix { };
  mlkit = pkgs.callPackage ./pkgs/mlkit.nix { };
  barry = pkgs.callPackage ./pkgs/barry.nix { inherit mlkit; };
  smltojs = pkgs.callPackage ./pkgs/smltojs.nix { inherit mlkit; };
  bencher = pkgs.callPackage ./pkgs/bencher.nix { };
  browsertrix-crawler = pkgs.callPackage ./pkgs/browsertrix-crawler.nix { };
  cdash = pkgs.callPackage ./pkgs/cdash.nix { };
  porkbun-ddns = pkgs.callPackage ./pkgs/porkbun-ddns.nix { };
  reddio = pkgs.callPackage ./pkgs/reddio.nix { };
  tmux-notify = pkgs.callPackage ./pkgs/tmux-notify.nix { };
  tubearchivist = pkgs.callPackage ./pkgs/tubearchivist.nix { };
}
