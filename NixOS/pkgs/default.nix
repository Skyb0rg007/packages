{pkgs ? import <nixpkgs> {}, ...}: {
  anemoi = pkgs.callPackage ./anemoi.nix {};
  ascsaver = pkgs.callPackage ./ascsaver.nix {};
  # maybe = pkgs.callPackage ./maybe {};
  mlton = pkgs.callPackage ./mlton.nix {};
  porkbun-ddns = pkgs.callPackage ./porkbun-ddns.nix {};
  # receipt-wrangler = pkgs.callPackage ./receipt-wrangler.nix {};
  # receipt-wrangler-desktop = pkgs.callPackage ./receipt-wrangler-desktop.nix {};
  # smlnj = pkgs.callPackage ./smlnj.nix {};
  smlnj-dev = pkgs.callPackage ./smlnj-dev.nix {};
  tmux-notify = pkgs.callPackage ./tmux-notify.nix {};
  recutils = pkgs.callPackage ./recutils.nix {};
  paperless-ai = pkgs.callPackage ./paperless-ai/default.nix {};
  archivebox = pkgs.callPackage ./archivebox.nix {};
  tubearchivist = pkgs.callPackage ./tubearchivist.nix {};
  reddio = pkgs.callPackage ./reddio.nix {};
  cdash = pkgs.callPackage ./cdash.nix {};
}
