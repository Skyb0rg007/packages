{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  networkmanager-clat = pkgs.callPackage ./networkmanager-clat.nix { };
  sbuild = pkgs.callPackage ./sbuild.nix { };
  keylime = pkgs.callPackage ./keylime.nix { };
  rust-keylime = pkgs.callPackage ./rust-keylime.nix { };
  # rsbinder = pkgs.callPackage ./rsbinder.nix { };
  rsbinder-aidl = pkgs.callPackage ./rsbinder-aidl.nix { };
  rsbinder-tools = pkgs.callPackage ./rsbinder-tools.nix { };

  # Radicle
  radicle-ci-ambient = pkgs.callPackage ./radicle-ci-ambient.nix { };
  radicle-woodpecker-addon = pkgs.callPackage ./radicle-woodpecker-addon.nix { };

  # Lars Wirzenius's Packages
  ambient-build-vm = pkgs.callPackage ./ambient-build-vm.nix { };
  ambient-ci = pkgs.callPackage ./ambient-ci.nix { };
  subplot = pkgs.callPackage ./subplot.nix { };
  vmdb2 = pkgs.callPackage ./vmdb2.nix { };

  anemoi = pkgs.callPackage ./anemoi.nix { };
  # archivebox = pkgs.callPackage ./archivebox.nix {};
  ascsaver = pkgs.callPackage ./ascsaver.nix { };
  barry = pkgs.callPackage ./barry.nix { };
  bencher = pkgs.callPackage ./bencher.nix { };
  browsertrix-crawler = pkgs.callPackage ./browsertrix-crawler.nix { };
  cdash = pkgs.callPackage ./cdash.nix { };
  paperless-ai = pkgs.callPackage ./paperless-ai.nix { };
  porkbun-ddns = pkgs.callPackage ./porkbun-ddns.nix { };
  reddio = pkgs.callPackage ./reddio.nix { };
  romm = pkgs.callPackage ./romm.nix { };
  tmux-notify = pkgs.callPackage ./tmux-notify.nix { };
  tubearchivist = pkgs.callPackage ./tubearchivist.nix { };
}
