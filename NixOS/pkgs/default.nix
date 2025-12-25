{pkgs ? import <nixpkgs> {}, ...}: {
  anemoi = pkgs.callPackage ./anemoi.nix {};
  ascsaver = pkgs.callPackage ./ascsaver.nix {};
  mlton = pkgs.callPackage ./mlton.nix {};
  porkbun-ddns = pkgs.callPackage ./porkbun-ddns.nix {};
  smlnj-dev = pkgs.callPackage ./smlnj-dev.nix {};
  tmux-notify = pkgs.callPackage ./tmux-notify.nix {};
  romm = pkgs.callPackage ./romm.nix {};

  subplot = pkgs.callPackage ./subplot.nix {};
  radicle-woodpecker-addon = pkgs.callPackage ./radicle-woodpecker-addon.nix {};
  ambient-ci = pkgs.callPackage ./ambient-ci.nix {};
  ambient-build-vm = pkgs.callPackage ./ambient-build-vm.nix {};
  vmdb2 = pkgs.callPackage ./vmdb2.nix {};
  radicle-ci-ambient = pkgs.callPackage ./radicle-ci-ambient.nix {};
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
