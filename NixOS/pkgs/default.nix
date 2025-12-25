{pkgs ? import <nixpkgs> {}, ...}: {
  anemoi = pkgs.callPackage ./anemoi.nix {};
  ascsaver = pkgs.callPackage ./ascsaver.nix {};
  porkbun-ddns = pkgs.callPackage ./porkbun-ddns.nix {};
  tmux-notify = pkgs.callPackage ./tmux-notify.nix {};
  romm = pkgs.callPackage ./romm.nix {};

  # Radicle
  radicle-ci-ambient = pkgs.callPackage ./radicle-ci-ambient.nix {};
  radicle-woodpecker-addon = pkgs.callPackage ./radicle-woodpecker-addon.nix {};

  # Lars Wirzenius's Packages
  ambient-build-vm = pkgs.callPackage ./ambient-build-vm.nix {};
  ambient-ci = pkgs.callPackage ./ambient-ci.nix {};
  subplot = pkgs.callPackage ./subplot.nix {};
  vmdb2 = pkgs.callPackage ./vmdb2.nix {};

  barry = pkgs.callPackage ./barry.nix {};
  bencher = pkgs.callPackage ./bencher.nix {};
  browsertrix-crawler = pkgs.callPackage ./browsertrix-crawler.nix {};
  # archivebox = pkgs.callPackage ./archivebox.nix {};
  cdash = pkgs.callPackage ./cdash.nix {};
  paperless-ai = pkgs.callPackage ./paperless-ai/default.nix {};
  recutils = pkgs.callPackage ./recutils.nix {};
  reddio = pkgs.callPackage ./reddio.nix {};
  tubearchivist = pkgs.callPackage ./tubearchivist.nix {};
}
