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

  pythonModuleNames = builtins.attrNames (builtins.readDir ./pkgs/python-modules);
  pythonOverride =
    interp:
    interp.override {
      packageOverrides =
        pself: _:
        lib.filesystem.packagesFromDirectoryRecursive {
          callPackage = pself.callPackage;
          directory = ./pkgs/python-modules;
        };
    };

  python3 = pythonOverride pkgs.python3;
  python313 = pythonOverride pkgs.python313;
  python314 = pythonOverride pkgs.python314;
  python315 = pythonOverride pkgs.python315;

  packages =
    lib.filesystem.packagesFromDirectoryRecursive {
      callPackage = lib.callPackageWith (
        pkgs
        // packages
        // {
          inherit
            python3
            python313
            python314
            python315
            nixosTests
            ;
          nixpkgs = pkgs;
        }
      );
      directory = ./pkgs/by-name;
    }
    // {
      python3Packages = packages.python313Packages;
      python313Packages = lib.genAttrs pythonModuleNames (n: python313.pkgs.${n});
      python314Packages = lib.genAttrs pythonModuleNames (n: python314.pkgs.${n});
      python315Packages = lib.genAttrs pythonModuleNames (n: python315.pkgs.${n});
      tcl9Packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = lib.callPackageWith (
          pkgs // packages // pkgs.tcl9Packages // packages.tcl9Packages // { inherit nixosTests; }
        );
        directory = ./pkgs/tcl-modules;
      };
    };
in
{
  inherit nixosModules;
}
// packages
