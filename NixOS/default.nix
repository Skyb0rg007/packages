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
  callPython3PackageWith =
    python3Packages:
    lib.callPackageWith (pkgs // packages // python3Packages // { inherit nixosTests; });

  # These override nixpkgs
  # XXX: Give mlkit, etc. different names from nixpkgs
  mlkit = callPackage ./pkgs/mlkit/default.nix { };
  brush = callPackage ./pkgs/brush/default.nix { };

  packages =
    lib.filesystem.packagesFromDirectoryRecursive {
      inherit callPackage;
      directory = ./pkgs/by-name;
    }
    // {
      python3Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = callPython3PackageWith pkgs.python3Packages;
        directory = ./pkgs/python-packages;
      };
      python313Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = callPython3PackageWith pkgs.python313Packages;
        directory = ./pkgs/python-packages;
      };
      python314Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = callPython3PackageWith pkgs.python314Packages;
        directory = ./pkgs/python-packages;
      };
      python315Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = callPython3PackageWith pkgs.python315Packages;
        directory = ./pkgs/python-packages;
      };
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
