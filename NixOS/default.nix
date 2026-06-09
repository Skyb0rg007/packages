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
  # XXX: Merge pkgs and packages so `pkgs.python3Packages` is merged
  callPackage = lib.callPackageWith (pkgs // packages // { inherit nixosTests; });
  callPython3PackageWith =
    name:
    lib.callPackageWith (
      pkgs // packages // pkgs.${name} // packages.${name} // { inherit nixosTests; }
    );
  callTcl9Package = lib.callPackageWith (
    pkgs // packages // pkgs.tcl9Packages // packages.tcl9Packages // { inherit nixosTests; }
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
        directory = ./pkgs/python-modules;
      };
      python313Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = callPython3PackageWith "python313Packages";
        directory = ./pkgs/python-modules;
      };
      python314Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = callPython3PackageWith "python314Packages";
        directory = ./pkgs/python-modules;
      };
      python315Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = callPython3PackageWith "python315Packages";
        directory = ./pkgs/python-modules;
      };
      tcl9Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = callTcl9Package;
        directory = ./pkgs/tcl-modules;
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
