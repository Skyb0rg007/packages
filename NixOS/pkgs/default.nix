{pkgs ? import <nixpkgs> {}, ...}: {
  anemoi = pkgs.callPackage ./anemoi.nix {};
  ascsaver = pkgs.callPackage ./ascsaver.nix {};
  mlton = pkgs.callPackage ./mlton.nix {};
  porkbun-ddns = pkgs.callPackage ./porkbun-ddns.nix {};
  smlnj-dev = pkgs.callPackage ./smlnj-dev.nix {};
  tmux-notify = pkgs.callPackage ./tmux-notify.nix {};
  recutils = pkgs.callPackage ./recutils.nix {};
  paperless-ai = pkgs.callPackage ./paperless-ai/default.nix {};
  archivebox = pkgs.callPackage ./archivebox.nix {};
  tubearchivist = pkgs.callPackage ./tubearchivist.nix {};
  reddio = pkgs.callPackage ./reddio.nix {};
  cdash = pkgs.callPackage ./cdash.nix {};
}
