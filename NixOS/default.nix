{
  pkgs ? import <nixpkgs> { config.allowUnfree = true; },
  lib ? pkgs.lib,
  ...
}:
let
  nixosModules = import ./modules/nixos;
  nixosTests = import ./tests/all-tests.nix {
    inherit pkgs nixosModules packages;
  };
  callPackage = lib.callPackageWith (pkgs // packages // { inherit nixosTests; });
  callPython3Package = lib.callPackageWith (
    pkgs // pkgs.python3Packages // packages // { inherit nixosTests; }
  );

  # These override nixpkgs
  # XXX: Give mlkit, etc. different names from nixpkgs
  mlkit = callPackage ./pkgs/mlkit/default.nix { };
  brush = callPackage ./pkgs/brush/default.nix { };

  packages =
    lib.filesystem.packagesFromDirectoryRecursive {
      inherit callPackage;
      directory = ./pkgs/by-name;
    }
    // lib.filesystem.packagesFromDirectoryRecursive {
      callPackage = callPython3Package;
      directory = ./pkgs/python-packages;
    };
in
{
  inherit
    nixosModules
    mlkit
    brush
    ;
}
// packages
