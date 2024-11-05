{pkgs ? import <nixpkgs> {}, ...}: {
  ascsaver = pkgs.callPackage ./ascsaver.nix {};
  maybe = pkgs.callPackage ./maybe {};
  mlton-dev = pkgs.callPackage ./mlton.nix {};
  porkbun-ddns = pkgs.callPackage ./porkbun-ddns.nix {};
  receipt-wrangler = pkgs.callPackage ./receipt-wrangler.nix {};
  receipt-wrangler-desktop = pkgs.callPackage ./receipt-wrangler-desktop.nix {};
  smlnj = pkgs.callPackage ./smlnj.nix {};
  smlnj-dev = pkgs.callPackage ./smlnj-dev.nix {};
  tmux-notify = pkgs.callPackage ./tmux-notify.nix {};
  recutils = pkgs.callPackage ./recutils.nix {};
}
