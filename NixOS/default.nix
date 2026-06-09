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
    name:
    lib.callPackageWith (
      pkgs // packages // pkgs.${name} // packages.${name} // { inherit nixosTests; }
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
    // {
      python3Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = callPython3PackageWith "python3Packages";
        directory = ./pkgs/python-packages;
      };
      python313Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = callPython3PackageWith "python313Packages";
        directory = ./pkgs/python-packages;
      };
      python314Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = callPython3PackageWith "python314Packages";
        directory = ./pkgs/python-packages;
      };
      python315Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = callPython3PackageWith "python315Packages";
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
